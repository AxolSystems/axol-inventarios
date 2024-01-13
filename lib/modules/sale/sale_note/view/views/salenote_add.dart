import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/appbar/appbar_global.dart';
import '../../../../../models/data_find.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/btn_select_inptu_form.dart';
import '../../../customer/model/customer_model.dart';
import '../../cubit/salenote_add/salenote_add_cubit.dart';
import '../../cubit/salenote_add/salenote_add_form.dart';
import '../../cubit/salenote_add/salenote_add_state.dart';
import '../../model/saelnote_add_form_model.dart';
import '../../model/sale_note_model.dart';
import '../../model/salenote_row_form_model.dart';

class SaleNoteAdd extends StatelessWidget {
  const SaleNoteAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteAddCubit, SaleNoteAddState>(
      bloc: context.read<SaleNoteAddCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingSaleNoteAddState) {
          return saleNoteAdd(context, [], true);
        } else if (state is LoadedSaleNoteAddState) {
          return saleNoteAdd(context, state.rowFormList, false);
        } else {
          return saleNoteAdd(context, [], false);
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleNoteAddState) {}
      },
    );
  }

  Widget saleNoteAdd(BuildContext context,
      List<SaleNoteRowFormModel> rowFormList, bool isLoading) {
    final form = context.read<SaleNoteAddForm>().state;
    SaleNoteAddFormModel upForm = form;
    TextEditingController customerCtrl = TextEditingController();
    TextEditingController vendorCtrl = TextEditingController();
    TextEditingController warehouseCtrl = TextEditingController();
    customerCtrl.value = TextEditingValue(
        text: form.customerTf.value,
        selection: TextSelection.collapsed(offset: form.customerTf.position));
    vendorCtrl.value = TextEditingValue(
        text: form.vendorTf.value,
        selection: TextSelection.collapsed(offset: form.vendorTf.position));
    warehouseCtrl.value = TextEditingValue(
        text: form.warehouseTf.value,
        selection: TextSelection.collapsed(offset: form.warehouseTf.position));
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarGlobal(
          title: 'Nueva nota de venta',
          iconButton: null,
          iconActions: [],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationUtilities.emptyNavRailReturn(),
          const VerticalDivider(
              thickness: 1, width: 1, color: ColorPalette.darkItems),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 270,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BtnSelectInputForm(
                                  controller: customerCtrl,
                                  icon: Icons.search,
                                  lblText: 'Cliente',
                                  errorText: form.customerTf.validation.isValid
                                      ? null
                                      : form.customerTf.validation.errorMessage,
                                  onChanged: (value) {
                                    upForm.customerTf.value = value;
                                    upForm.customerTf.position =
                                        customerCtrl.selection.base.offset;
                                    context
                                        .read<SaleNoteAddForm>()
                                        .setForm(upForm);
                                  },
                                  onSubmitted: (value) {
                                    upForm =
                                        context.read<SaleNoteAddForm>().state;
                                    context
                                        .read<SaleNoteAddCubit>()
                                        .fetchCustomer(value, upForm);
                                  },
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ProviderCustomerFind(),
                                    ).then((value) {
                                      if (value is DataFind &&
                                          value.data is CustomerModel) {
                                        upForm.customerTf.value =
                                            '${value.id} - ${value.data.name}';
                                        upForm.customer = value.data;
                                        context
                                            .read<SaleNoteAddForm>()
                                            .setForm(upForm);
                                        context.read<SaleNoteAddCubit>().load();
                                      }
                                    });
                                  },
                                ),
                                Text(
                                    '${CustomerModel.lblPhoneNumber} ${form.customer.phoneNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblRfc} ${form.customer.rfc}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblStreet} ${form.customer.street}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblOutNumber} ${form.customer.outNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblIntNumber} ${form.customer.intNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblHood} ${form.customer.hood}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblPostalCode} ${form.customer.postalCode}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblTown} ${form.customer.town}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblCountry} ${form.customer.country}',
                                    style: Typo.labelLight),
                              ],
                            ),
                          )),
                      const VerticalDivider(
                        color: ColorPalette.darkItems,
                        width: 1,
                        thickness: 1,
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Número: ${form.id}',
                                    style: Typo.labelLight),
                                Text('Fecha: ${form.dateTime}',
                                    style: Typo.labelLight),
                                BtnSelectInputForm(
                                  icon: Icons.search,
                                  lblText: 'Vendedor',
                                  controller: vendorCtrl,
                                  onChanged: (value) {
                                    upForm.vendorTf.value = value;
                                    upForm.vendorTf.position =
                                        vendorCtrl.selection.base.offset;
                                    context
                                        .read<SaleNoteAddForm>()
                                        .setForm(upForm);
                                  },
                                  onSubmitted: (value) {
                                    context.read<SaleNoteAddCubit>().load();
                                  },
                                ),
                                BtnSelectInputForm(
                                  icon: Icons.search,
                                  lblText: 'Almacén',
                                  controller: warehouseCtrl,
                                  onChanged: (value) {
                                    upForm.warehouseTf.value = value;
                                    upForm.warehouseTf.position =
                                        warehouseCtrl.selection.base.offset;
                                    context
                                        .read<SaleNoteAddForm>()
                                        .setForm(upForm);
                                  },
                                  onSubmitted: (value) {
                                    context.read<SaleNoteAddCubit>().load();
                                  },
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecorationTheme.headerTable(),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Cantidad', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Producto', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Descripición', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            Text('Precio unitario', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Subtotal', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Nota', style: Typo.subtitleLight),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rowFormList.length,
                    itemBuilder: (context, index) {
                      final row = rowFormList[index];
                      //final total =
                      return Container(
                        decoration: BoxDecorationTheme.rowTable(),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(child: TextField()),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(row.description),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(row.description),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
