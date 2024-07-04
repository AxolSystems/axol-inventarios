import 'package:axol_inventarios/modules/sale_report/model/salereport_row_model.dart';
import 'package:axol_inventarios/modules/sale_report/model/srp_add_row_form_model.dart';
import 'package:axol_inventarios/modules/sale_report/view/srp_find_bottomsheet.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../cubit/add/srp_add_row_cubit.dart';

class SrpAddRowDrawer extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final SaleReportRowModel? rowEdit;
  const SrpAddRowDrawer({super.key, required this.inventoryList, this.rowEdit});

  @override
  Widget build(BuildContext context) {
    InventoryRowModel? inventoryRow;
    if (rowEdit != null) {
      inventoryRow = inventoryList.firstWhere(
          (x) => x.product.code == rowEdit!.product.code,
          orElse: InventoryRowModel.empty);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpAddRowCubit()),
        BlocProvider(create: (_) => SrpAddRowForm(rowEdit, inventoryRow)),
      ],
      child:
          WbAddRowDrawerBuild(inventoryList: inventoryList, rowEdit: rowEdit),
    );
  }
}

class WbAddRowDrawerBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final SaleReportRowModel? rowEdit;
  const WbAddRowDrawerBuild(
      {super.key, required this.inventoryList, this.rowEdit});

  @override
  Widget build(BuildContext context) {
    SrpAddRowFormModel form = context.read<SrpAddRowForm>().state;
    return BlocConsumer<SrpAddRowCubit, SrpAddRowState>(
      bloc: context.read<SrpAddRowCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == SrpAddRowState.loading) {
          return wbAddRowDrawer(context, inventoryList, form);
        } else if (state == SrpAddRowState.load) {
          return wbAddRowDrawer(context, inventoryList, form);
        } else {
          return wbAddRowDrawer(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == SrpAddRowState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessageQty ?? 'null',
                  ));
        }
        if (state == SrpAddRowState.save) {
          final SaleReportRowModel saleReportRow = SaleReportRowModel(
            product: form.product,
            customerName: form.customerCtrl.text,
            quantity: double.tryParse(form.qtyCtrl.text) ?? 0,
            unitPrice: double.tryParse(form.unitPriceCtrl.text) ?? 0,
          );
          if (form.errorMessagePrice == null && form.errorMessageQty == null) {
            Navigator.pop(context, saleReportRow);
          }
        }
      },
    );
  }

  Widget wbAddRowDrawer(
    BuildContext context,
    List<InventoryRowModel> inventoryList,
    SrpAddRowFormModel form,
  ) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double widthDrawer;
    final double subTotal;
    final double quantity;
    final double unitPrice;
    quantity = double.tryParse(form.qtyCtrl.text) ?? 0;
    unitPrice = double.tryParse(form.unitPriceCtrl.text) ?? 0;
    subTotal = quantity * unitPrice;

    if (rowEdit != null) {
      widthDrawer = 0.05;
    } else {
      widthDrawer = 0;
    }

    return DrawerBox(
      width: widthScreen < 600 ? (0.95 - widthDrawer) : (0.5 - widthDrawer),
      header: Visibility(
        visible: widthScreen < 600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorPalette.darkItems20,
                )),
          ],
        ),
      ),
      actions: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal: ', style: Typo.systemDark),
                    Text(
                      '\$ ${FormatNumber.format2dec(subTotal)}',
                      style: Typo.systemDark,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      side: const BorderSide(
                        color: ColorPalette.primary,
                        width: 1,
                      ),
                    ),
                    onPressed: () {
                      context.read<SrpAddRowCubit>().save(form);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.save,
                            color: ColorPalette.lightBackground,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Guardar',
                            style: Typo.mobileLight20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorPalette.lightItems10)),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12))),
                context: context,
                builder: (context) =>
                    SrpFindBottomsheet(inventoryRowList: inventoryList),
              ).then((value) {
                if (value is InventoryRowModel) {
                  form.product = value.product;
                  form.stock = value.stock;
                  context.read<SrpAddRowCubit>().load(form);
                }
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                      visible: form.product.code != '',
                      replacement: const SizedBox(height: 50),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Clave',
                                      style: Typo.smallLabelDark,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      form.product.code,
                                      style: Typo.bodyDark,
                                      textAlign: TextAlign.left,
                                    ),
                                  ]),
                              const SizedBox(width: 8),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Stock',
                                      style: Typo.smallLabelDark,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      FormatNumber.format2dec(form.stock),
                                      style: Typo.bodyDark,
                                      textAlign: TextAlign.left,
                                    ),
                                  ]),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Descripción',
                                    style: Typo.smallLabelDark,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    form.product.description,
                                    style: Typo.bodyDark,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      )),
                ),
                const Icon(
                  Icons.search,
                  color: ColorPalette.lightItems10,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            style: Typo.bodyDark,
            controller: form.qtyCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: const Text('Cantidad', style: Typo.bodyDark),
              border: const OutlineInputBorder(),
              hintText: 'Cantidad',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              errorText: form.errorMessageQty,
            ),
            onChanged: (value) {
              context.read<SrpAddRowCubit>().load(form);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            style: Typo.bodyDark,
            controller: form.unitPriceCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: const Text('Precio unitario', style: Typo.bodyDark),
              border: const OutlineInputBorder(),
              hintText: 'Precio unitario',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              errorText: form.errorMessagePrice,
              prefixText: '\$ ',
            ),
            onChanged: (value) {
              context.read<SrpAddRowCubit>().load(form);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            style: Typo.bodyDark,
            controller: form.customerCtrl,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Cliente (opcional)', style: Typo.bodyDark),
              border: OutlineInputBorder(),
              hintText: 'Cliente (opcional)',
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}
