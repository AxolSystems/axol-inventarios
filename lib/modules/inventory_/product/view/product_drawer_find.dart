import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_find.dart';
import '../../../../utilities/theme/textfield_decoration.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/drawer_find.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../inventory/model/warehouse_model.dart';
import '../cubit/product_find/product_find_cubit.dart';
import '../model/product_find_form_model.dart';

class ProductDrawerFind extends StatelessWidget {
  final WarehouseModel warehouse;
  const ProductDrawerFind({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ProductFindCubit()),
            BlocProvider(create: (_) => ProductFindForm()),
          ],
          child: ProductDrawerFindBuild(
            warehouse: warehouse,
          ));
}

class ProductDrawerFindBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const ProductDrawerFindBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    ProductFindFormModel form = context.read<ProductFindForm>().state;
    const String lblText = 'Producto';

    return BlocConsumer<ProductFindCubit, DrawerFindState>(
      bloc: context.read<ProductFindCubit>()..load(form, warehouse, currentPage: 1),
      builder: (context, state) {
        if (state is LoadingDrawerFindState) {
          return productDrawerFind(
            context: context,
            isLoading: true,
            lblText: lblText,
            form: form,
          );
        } else if (state is LoadedDrawerFindState) {
          return productDrawerFind(
            context: context,
            isLoading: false,
            lblText: lblText,
            listValues: state.valuesList,
            form: form,
          );
        } else {
          return productDrawerFind(
            context: context,
            isLoading: false,
            lblText: lblText,
            form: form,
          );
        }
      },
      listener: (context, state) {
        if (state is ErrorDrawerFindState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget productDrawerFind({
    required BuildContext context,
    required bool isLoading,
    required String lblText,
    required ProductFindFormModel form,
    List<DataFindValues>? listValues,
  }) {
    List<DataFindValues> listValues_ = listValues ?? [];
    List<Widget> subtitleList_ = [];
    Widget subtitle;

    final List<DrawerColumn> subtitleList;
    if (form.productListFind == ProductListFind.inventory) {
      subtitleList = [
        DrawerColumn('Id', flex: 1),
        DrawerColumn('Descripción', flex: 3),
        DrawerColumn('Stock', flex: 1),
      ];
    } else if (form.productListFind == ProductListFind.product) {
      subtitleList = [
        DrawerColumn('Id', flex: 1),
        DrawerColumn('Descripción', flex: 5),
      ];
    } else {
      subtitleList = [];
    }

    for (DrawerColumn element in subtitleList) {
      subtitle = Expanded(
          flex: element.flex ?? 1,
          child: Text(
            element.subtitle,
            style: Typo.subtitleDark,
            textAlign: TextAlign.center,
          ));
      subtitleList_.add(subtitle);
    }

    return DrawerBox(
      padding: const EdgeInsets.all(8),
      header: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        form.productListFind == ProductListFind.inventory
                            ? ColorPalette.filled
                            : ColorPalette.lightBackground,
                    side: const BorderSide(color: ColorPalette.lightItems10),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          form.productListFind = ProductListFind.inventory;
                          context
                              .read<ProductFindCubit>()
                              .load(form, warehouse, currentPage: 1);
                        },
                  child: Text(
                    'Inventario almacén actual',
                    style: form.productListFind == ProductListFind.inventory
                        ? Typo.systemDark
                        : Typo.labelLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      form.productListFind == ProductListFind.product
                          ? ColorPalette.filled
                          : ColorPalette.lightBackground,
                  side: const BorderSide(
                      color: ColorPalette.lightItems10, width: 1),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        form.productListFind = ProductListFind.product;
                        context.read<ProductFindCubit>().load(form, warehouse, currentPage: 1);
                      },
                child: Text(
                  'Todos los productos',
                  style: form.productListFind == ProductListFind.product
                      ? Typo.systemDark
                      : Typo.labelLight,
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: form.tfFind.controller,
                  autofocus: true,
                  decoration: TextFieldDecoration.inputForm(lblText: lblText),
                  cursorColor: ColorPalette.primary,
                  style: Typo.bodyDark,
                  onSubmitted: isLoading == false
                      ? (value) {
                          context
                              .read<ProductFindCubit>()
                              .load(form, warehouse, currentPage: 1);
                        }
                      : null,
                ),
              ),
              IconButton(
                onPressed: isLoading == false
                    ? () {
                      form.tfFind.controller.value = TextEditingValue.empty;
                        context.read<ProductFindCubit>().load(form, warehouse, currentPage: 1);
                      }
                    : null,
                icon: const Icon(
                  Icons.close,
                  color: ColorPalette.lightItems10,
                ),
              )
            ],
          ),
          Visibility(
            visible: subtitleList_.isNotEmpty && isLoading != true,
            child: Row(
              children: subtitleList_,
            ),
          ),
        ],
      ),
      actions: [
        SecondaryButtonDialog(
          text: '',
          icon: const Icon(Icons.arrow_back, color: ColorPalette.lightItems10),
          onPressed: () {
            if (form.currentPage > 1) {
              form.currentPage = form.currentPage--;
              context.read<ProductFindCubit>().load(form, warehouse);
            }
          },
        ),
        Text('${form.currentPage} de ${form.limitPage}', style: Typo.bodyDark),
        SecondaryButtonDialog(
          text: '',
          icon: const Icon(Icons.arrow_forward, color: ColorPalette.lightItems10),
          onPressed: () {
            if (form.currentPage < form.limitPage) {
              form.currentPage++;
              context.read<ProductFindCubit>().load(form, warehouse);
            }
          },
        ),
        Text('${form.totalReg} registros', style: Typo.bodyDark),
        const Expanded(child: SizedBox()),
        SecondaryButtonDialog(
          enabled: false,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      child: isLoading != true
          ? Expanded(
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: listValues_.length,
              itemBuilder: (context, index) {
                final data = listValues_[index];
                Widget contentElement;
                List<Widget> listContent = [];
                int flex;
                for (int i = 0; i < data.values.length; i++) {
                  final value = data.values[i];
                  if (i >= subtitleList.length ||
                      subtitleList[i].flex == null) {
                    flex = 1;
                  } else {
                    flex = subtitleList[i].flex ?? 1;
                  }
                  contentElement = Expanded(
                    flex: flex,
                    child: Text(
                      value,
                      style: Typo.bodyDark,
                      textAlign: TextAlign.center,
                    ),
                  );
                  listContent.add(contentElement);
                }
                return ButtonRowTable(
                  onPressed: () {
                    Navigator.pop(context, data);
                  },
                  child: Row(
                    children: listContent,
                  ),
                );
              },
            ))
          : const Expanded(
              child: Column(
                children: [
                  LinearProgressIndicatorAxol(),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
    );
  }
}
