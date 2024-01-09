import 'package:axol_inventarios/modules/sale/customer/cubit/customer_tab/customer_tab_form.dart';
import 'package:axol_inventarios/modules/sale/customer/view/customer_drawer_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/progress_indicator.dart';
import '../../../../utilities/widgets/providers.dart';
import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../cubit/customer_tab/customer_tab_cubit.dart';
import '../cubit/customer_tab/customer_tab_state.dart';
import '../model/customer_model.dart';

class CustomerTab extends StatelessWidget {
  const CustomerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerTabCubit, CustomerTabState>(
      bloc: context.read<CustomerTabCubit>()..load(''),
      listener: (context, state) {
        if (state is ErrorCustomerTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) {
        if (state is LoadingCustomerTabState) {
          return customerTab(context, [], true);
        } else if (state is LoadedCustomerTabState) {
          return customerTab(context, state.customerList, false);
        } else {
          return customerTab(context, [], false);
        }
      },
    );
  }

  Column customerTab(
      BuildContext context, List<CustomerModel> customerList, bool isLoading) {
    TextfieldModel form = context.read<CustomerTabForm>().state;
    TextfieldModel upForm;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: form.text,
        selection: TextSelection.collapsed(offset: form.position));
    return Column(
      children: [
        Container(
          height: 50,
          color: ColorPalette.lightBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FinderBar(
                  padding: const EdgeInsets.only(left: 12),
                  textController: textController,
                  txtForm: form,
                  enabled: !isLoading,
                  autoFocus: true,
                  isTxtExpand: true,
                  onSubmitted: (value) {
                    context.read<CustomerTabCubit>().load(value);
                  },
                  onChanged: (value) {
                    upForm = TextfieldModel(
                        text: value,
                        position: textController.selection.base.offset);
                    context.read<CustomerTabForm>().setForm(upForm);
                  },
                  onPressed: () {
                    if (isLoading == false) {
                      context
                          .read<CustomerTabForm>()
                          .setForm(TextfieldModel.empty());
                      context.read<CustomerTabCubit>().load('');
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
                    context.read<CustomerTabCubit>().load(form.text);
                  });
                },
                icon: const Icon(
                  Icons.add_outlined,
                  color: ColorPalette.darkItems,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
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
                      /*const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1,
                        color: ColorPalette.darkItems,
                      ))),*/
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
                            context.read<CustomerTabCubit>().load(form.text);
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
