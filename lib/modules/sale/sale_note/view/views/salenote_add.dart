import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/appbar_axol.dart';
import '../../../../../models/data_find.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/btn_select_inptu_form.dart';
import '../../../../../utilities/widgets/input_table.dart';
import '../../../../../utilities/widgets/toolbar.dart';
import '../../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../customer/model/customer_model.dart';
import '../../../vendor/model/vendor_model.dart';
import '../../cubit/salenote_add/salenote_add_cubit.dart';
import '../../cubit/salenote_add/salenote_add_form.dart';
import '../../cubit/salenote_add/salenote_add_state.dart';
import '../../model/saelnote_add_form_model.dart';
import '../../model/salenote_row_form_model.dart';

class SaleNoteAdd extends StatelessWidget {
  const SaleNoteAdd({super.key});

  String _toEmptyString(int num) {
    final String string;
    if (num < 0) {
      string = '';
    } else {
      string = num.toString();
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    final form = context.read<SaleNoteAddForm>().state;
    return BlocConsumer<SaleNoteAddCubit, SaleNoteAddState>(
      bloc: context.read<SaleNoteAddCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingSaleNoteAddState) {
          return saleNoteAdd(context, form.productList, true);
        } else if (state is LoadedSaleNoteAddState) {
          return saleNoteAdd(context, form.productList, false);
        } else {
          return saleNoteAdd(context, [], false);
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleNoteAddState) {
          print(state.error);
        }
      },
    );
  }

  Widget saleNoteAdd(BuildContext context,
      List<SaleNoteRowFormModel> productList, bool isLoading) {
    final form = context.read<SaleNoteAddForm>().state;
    String dateText =
        '${form.dateTime.day}/${form.dateTime.month}/${form.dateTime.year}';
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
      appBar: AppBarAxol(
        title: 'Nueva nota de venta',
        isLoading: isLoading,
      ).appBarAxol(),
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
                                  isLoading: isLoading,
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
                                        context
                                            .read<SaleNoteAddCubit>()
                                            .fetchCustomer(
                                                value.id.toString(), upForm);
                                      }
                                    });
                                  },
                                ),
                                Text(
                                    '${CustomerModel.lblPhoneNumber} ${_toEmptyString(form.customer.phoneNumber ?? -1)}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblRfc} ${form.customer.rfc}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblStreet} ${form.customer.street}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblOutNumber} ${_toEmptyString(form.customer.outNumber ?? -1)}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblIntNumber} ${_toEmptyString(form.customer.intNumber ?? -1)}',
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
                                Text('Folio: ${_toEmptyString(form.id)}',
                                    style: Typo.labelLight),
                                Text('Fecha: $dateText',
                                    style: Typo.labelLight),
                                BtnSelectInputForm(
                                  icon: Icons.search,
                                  lblText: 'Vendedor',
                                  controller: vendorCtrl,
                                  isLoading: isLoading,
                                  errorText: form.vendorTf.validation.isValid
                                      ? null
                                      : form.vendorTf.validation.errorMessage,
                                  onChanged: (value) {
                                    upForm.vendorTf.value = value;
                                    upForm.vendorTf.position =
                                        vendorCtrl.selection.base.offset;
                                    context
                                        .read<SaleNoteAddForm>()
                                        .setForm(upForm);
                                  },
                                  onSubmitted: (value) {
                                    upForm =
                                        context.read<SaleNoteAddForm>().state;
                                    context
                                        .read<SaleNoteAddCubit>()
                                        .fetchVendor(value, upForm);
                                  },
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ProviderVendorFind(),
                                    ).then((value) {
                                      if (value is DataFind &&
                                          value.data is VendorModel) {
                                        upForm.vendorTf.value =
                                            '${value.id} - ${value.data.name}';
                                        context
                                            .read<SaleNoteAddForm>()
                                            .setForm(upForm);
                                        context
                                            .read<SaleNoteAddCubit>()
                                            .fetchVendor(
                                                value.id.toString(), upForm);
                                      }
                                    });
                                  },
                                ),
                                BtnSelectInputForm(
                                  icon: Icons.search,
                                  lblText: 'Almacén',
                                  controller: warehouseCtrl,
                                  isLoading: isLoading,
                                  errorText: form.warehouseTf.validation.isValid
                                      ? null
                                      : form
                                          .warehouseTf.validation.errorMessage,
                                  onChanged: (value) {
                                    upForm.warehouseTf.value = value;
                                    upForm.warehouseTf.position =
                                        warehouseCtrl.selection.base.offset;
                                    context
                                        .read<SaleNoteAddForm>()
                                        .setForm(upForm);
                                  },
                                  onSubmitted: (value) {
                                    upForm =
                                        context.read<SaleNoteAddForm>().state;
                                    context
                                        .read<SaleNoteAddCubit>()
                                        .fetchWarehouse(value, upForm);
                                  },
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ProviderWarehouseFind(),
                                    ).then((value) {
                                      if (value is DataFind &&
                                          value.data is WarehouseModel) {
                                        upForm.warehouseTf.value =
                                            '${value.id} - ${value.data.name}';
                                        context
                                            .read<SaleNoteAddForm>()
                                            .setForm(upForm);
                                        context
                                            .read<SaleNoteAddCubit>()
                                            .fetchWarehouse(
                                                value.id.toString(), upForm);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                          decoration: BoxDecorationTheme.headerTable(),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Cantidad',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Producto',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Descripición',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Precio unitario',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Subtotal',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Nota',
                                  style: Typo.subtitleLight,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final row = productList[index];
                              TextEditingController quantityCtrl =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: row.quantity.value,
                                selection: TextSelection.collapsed(
                                    offset: row.quantity.position),
                              ));
                              TextEditingController productCtrl =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                text: row.productCode.value,
                                selection: TextSelection.collapsed(
                                    offset: row.productCode.position),
                              ));
                              TextEditingController priceCtrl =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                          text: row.unitPrice.value,
                                          selection: TextSelection.collapsed(
                                              offset: row.unitPrice.position)));
                              final int quantity =
                                  int.tryParse(row.quantity.value) ?? 0;
                              final int price =
                                  int.tryParse(row.unitPrice.value) ?? 0;
                              final total = quantity * price;
                              final bool isQuantityFocus =
                                  upForm.productList[index].quantity.isFocus ??
                                      false;
                              final bool isProductFocus = upForm
                                      .productList[index].productCode.isFocus ??
                                  false;
                              final bool isPriceFocus =
                                  upForm.productList[index].unitPrice.isFocus ??
                                      false;
                              return InputRow(
                                children: [
                                  TextFieldCell(
                                      valid: row.quantity.validation,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*$'))
                                      ],
                                      controller: quantityCtrl,
                                      onSubmitted: (value) {
                                        upForm = context
                                            .read<SaleNoteAddForm>()
                                            .state;
                                        context
                                            .read<SaleNoteAddCubit>()
                                            .validateCell(
                                                upForm, row.keyQuantity, index);
                                      },
                                      onChanged: (value) {
                                        upForm.productList[index].quantity
                                            .value = value;
                                        upForm.productList[index].quantity
                                                .position =
                                            quantityCtrl.selection.base.offset;
                                        context
                                            .read<SaleNoteAddForm>()
                                            .setForm(upForm);
                                      },
                                      borderColor: isQuantityFocus
                                          ? ColorPalette.primary
                                          : ColorPalette.darkItems),
                                  TextFieldCell(
                                    controller: productCtrl,
                                    isActionVisible: true,
                                    valid: row.productCode.validation,
                                    onChanged: (value) {
                                      upForm.productList[index].productCode
                                          .value = value;
                                      upForm.productList[index].productCode
                                              .position =
                                          quantityCtrl.selection.base.offset;
                                      context
                                          .read<SaleNoteAddForm>()
                                          .setForm(upForm);
                                    },
                                    onSubmitted: (value) {
                                      context
                                          .read<SaleNoteAddCubit>()
                                          .validateCell(
                                              upForm, row.keyProduct, index);
                                    },
                                    borderColor: isProductFocus
                                        ? ColorPalette.primary
                                        : ColorPalette.darkItems,
                                  ),
                                  LabelCell(
                                    'Descripción',
                                    alignment: Alignment.center,
                                  ),
                                  TextFieldCell(
                                    controller: priceCtrl,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*$'))
                                    ],
                                    onChanged: (value) {
                                      upForm.productList[index].unitPrice
                                          .value = value;
                                      upForm.productList[index].unitPrice
                                              .position =
                                          quantityCtrl.selection.base.offset;
                                      context
                                          .read<SaleNoteAddForm>()
                                          .setForm(upForm);
                                    },
                                    onSubmitted: (value) {
                                      context
                                          .read<SaleNoteAddCubit>()
                                          .validateCell(
                                              upForm, row.keyPrice, index);
                                    },
                                    borderColor: isPriceFocus
                                        ? ColorPalette.primary
                                        : ColorPalette.darkItems,
                                  ),
                                  LabelCell('Total'),
                                  ButtonCell(
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.sticky_note_2,
                                        color: ColorPalette.lightItems,
                                        size: 20,
                                      )),
                                ],
                              );
                              /*Container(
                            height: 30,
                            decoration: BoxDecorationTheme.rowTable(),
                            child: Row(
                              children: [
                                //Cantidad
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                //Calve de producto
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        decoration: InputDecoration(
                                          isDense: true,
                                        ),
                                      )),
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.search,
                                          color: ColorPalette.lightItems,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Descripcion del producto
                                Expanded(
                                  flex: 1,
                                  child: Text(row.description),
                                ),
                                //Precio unitario
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                //Total
                                Expanded(
                                  flex: 1,
                                  child: Text('$total'),
                                ),
                                Expanded(
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit_note,
                                      color: ColorPalette.lightItems,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );*/
                            },
                          ),
                        ),
                      ],
                    )),
                    HorizontalToolBar(
                      border: const Border(
                        left: BorderSide(color: ColorPalette.darkItems),
                        top: BorderSide(color: ColorPalette.darkItems),
                      ),
                      children: [
                        SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              foregroundColor: ColorPalette.primary,
                              shape: const RoundedRectangleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: ColorPalette.lightItems,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              context
                                  .read<SaleNoteAddCubit>().test();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              foregroundColor: ColorPalette.primary,
                              shape: const RoundedRectangleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.save,
                              color: ColorPalette.lightItems,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
