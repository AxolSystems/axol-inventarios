import 'package:axol_inventarios/modules/inventory_/product/view/product_drawer_details.dart';
import 'package:axol_inventarios/utilities/widgets/table_view/tableview_form.dart';
import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../cubit/product_tab/product_tab_cubit.dart';
import '../cubit/product_tab/product_tab_state.dart';
import '../model/product_model.dart';

class ProductTab extends StatelessWidget {
  const ProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductTabCubit()),
        BlocProvider(create: (_) => TableViewFormCubit()),
      ],
      child: const ProductTabBuild(),
    );
  }
}

class ProductTabBuild extends StatelessWidget {
  const ProductTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<TableViewFormCubit>().state;
    return BlocConsumer<ProductTabCubit, ProductTabState>(
      bloc: context.read<ProductTabCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingProductTabState) {
          return productTab(context, [], true, form);
        } else if (state is LoadedProductTabState) {
          return productTab(context, state.products, false, form);
        } else {
          return productTab(context, [], false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorProductTabState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget productTab(BuildContext context, List<ProductModel> productList,
      bool isLoading, TableViewFormModel form) {
    TextEditingController textController = TextEditingController.fromValue(
        TextEditingValue(
            text: form.finder.text,
            selection: TextSelection.collapsed(offset: form.finder.position)));

    return Column(
      children: [
        VerticalToolBar(
          children: [
            Expanded(
                child: FinderBar(
              padding: const EdgeInsets.only(left: 12),
              textController: textController,
              txtForm: form.finder,
              enabled: !isLoading,
              autoFocus: true,
              isTxtExpand: true,
              onSubmitted: (value) {
                form.currentPage = 1;
                context.read<ProductTabCubit>().load(form);
              },
              onChanged: (value) {
                form.finder = TextfieldModel(
                    text: value,
                    position: textController.selection.base.offset);
              },
              onPressed: () {
                if (isLoading == false) {
                  form.finder = TextfieldModel.empty();
                  context.read<ProductTabCubit>().load(form);
                }
              },
            )),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: ColorPalette.lightItems,
              indent: 4,
              endIndent: 4,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.add_outlined,
                color: ColorPalette.darkItems,
                size: 30,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecorationTheme.headerTable(),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Clave',
                    style: Typo.subtitleLight,
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Descripción',
                    style: Typo.subtitleLight,
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Tipo',
                    style: Typo.subtitleLight,
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Peso',
                    style: Typo.subtitleLight,
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Empaque',
                    style: Typo.subtitleLight,
                  )),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Column(
                  children: [
                    LinearProgressIndicatorAxol(),
                    Expanded(child: SizedBox())
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final productRow = productList[index];
                    return Container(
                      height: 30,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorPalette.darkItems),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: ButtonRowTable(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ProductDrawerDetails(
                                        product: productRow,
                                        actions: true,
                                      )).then((value) {
                                        context.read<ProductTabCubit>().load(form);
                                      });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  //1) Clave
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      productRow.code,
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // 2) Descripción
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      productRow.description,
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // 3) Tipo
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      productRow.type.toString(),
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // 4) Peso
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      '${productRow.weight} KG',
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // 5) Empaque
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      productRow.packing.toString(),
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    );
                  },
                ),
        ),
        NavigateBar(
          currentPage: form.currentPage,
          limitPaga: form.limitPage,
          totalReg: form.totalReg,
          onPressedLeft: () {
            if (form.currentPage > 1) {
              form.currentPage = form.currentPage - 1;
              context.read<ProductTabCubit>().load(form);
            }
          },
          onPressedRight: () {
            if (form.currentPage < form.limitPage) {
              form.currentPage = form.currentPage + 1;
              context.read<ProductTabCubit>().load(form);
            }
          },
        ),
      ],
    );
  }
}
