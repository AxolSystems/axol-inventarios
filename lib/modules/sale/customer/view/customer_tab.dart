import 'package:axol_inventarios/modules/sale/customer/cubit/customer_tab/customer_tab_form.dart';
import 'package:axol_inventarios/modules/sale/customer/view/customer_drawer_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/providers.dart';
import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../cubit/customer_tab/customer_tab_cubit.dart';
import '../cubit/customer_tab/customer_tab_state.dart';
import '../model/customer_model.dart';

class CustomerTab extends Providers {
  const CustomerTab({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => CustomerTabCubit()),
        BlocProvider(create: (_) => CustomerTabForm()),
      ], child: const CustomerTabBuild());
}

class CustomerTabBuild extends StatelessWidget {
  const CustomerTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<CustomerTabForm>().state;
    return BlocConsumer<CustomerTabCubit, CustomerTabState>(
      bloc: context.read<CustomerTabCubit>()..initLoad(form),
      listener: (context, state) {
        if (state is ErrorCustomerTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) {
        if (state is LoadingCustomerTabState) {
          return customerTab(context, [], true, form);
        } else if (state is LoadedCustomerTabState) {
          return customerTab(context, state.customerList, false, form);
        } else {
          return customerTab(context, [], false, form);
        }
      },
    );
  }

  Column customerTab(BuildContext context, List<CustomerModel> customerList,
      bool isLoading, TableViewFormModel form) {
    //TableViewFormModel upForm;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: form.finder.text,
        selection: TextSelection.collapsed(offset: form.finder.position));
    return Column(
      children: [
        VerticalToolBar(children: [
          Expanded(
            child: FinderBar(
              padding: const EdgeInsets.only(left: 12),
              textController: textController,
              txtForm: form.finder,
              enabled: !isLoading,
              autoFocus: true,
              isTxtExpand: true,
              onSubmitted: (value) {
                form.finder = TextfieldModel(
                    text: value,
                    position: textController.selection.base.offset);
                context.read<CustomerTabCubit>().load(form);
              },
              onChanged: (value) {
                form.finder = TextfieldModel(
                    text: value,
                    position: textController.selection.base.offset);
                //context.read<CustomerTabForm>().setForm(form);
              },
              onPressed: () {
                if (isLoading == false) {
                  /*context
                      .read<CustomerTabForm>()
                      .setForm(TextfieldModel.empty());*/
                  form.finder = TextfieldModel.empty();
                  context.read<CustomerTabCubit>().load(form);
                }
              },
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: ColorPalette.lightItems,
            indent: 4,
            endIndent: 4,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ProviderCustomerAdd(),
              ).then((value) {
                context.read<CustomerTabCubit>().load(form);
              });
            },
            icon: const Icon(
              Icons.add_outlined,
              color: ColorPalette.darkItems,
              size: 30,
            ),
          ),
        ]),
        Container(
          decoration: BoxDecorationTheme.headerTable(),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Id',
                      style: Typo.subtitleLight,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Nombre',
                    style: Typo.subtitleLight,
                  ),
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
                  itemCount: customerList.length,
                  itemBuilder: (context, index) {
                    final customer = customerList[index];
                    return Container(
                      decoration: BoxDecorationTheme.rowTable(),
                      child: ButtonRowTable(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  customer.id.toString(),
                                  style: Typo.bodyLight,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                customer.name.toString(),
                                style: Typo.bodyLight,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                CustomerDrawerDetails(customer: customer),
                          ).then((value) {
                            context
                                .read<CustomerTabCubit>()
                                .load(form);
                          });
                        },
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
              context.read<CustomerTabCubit>().load(form);
            }
          },
          onPressedRight: () {
            if (form.currentPage < form.limitPage) {
              form.currentPage = form.currentPage + 1;
              context.read<CustomerTabCubit>().load(form);
            }
          },
        ),
      ],
    );
  }
}
