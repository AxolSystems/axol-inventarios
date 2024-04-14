import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/add/srp_add_bottomsheet_cubit.dart';
import '../model/salereport_row_model.dart';
import '../model/srp_add_bottomsheet_form_model.dart';
import 'srp_find_bottomsheet.dart';

class SrpAddBottomsheet extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  const SrpAddBottomsheet({super.key, required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpAddBottomsheetCubit()),
        BlocProvider(create: (_) => SrpAddBottomsheetForm()),
      ],
      child: WbAddBottomSheetBuild(inventoryList: inventoryList),
    );
  }
}

class WbAddBottomSheetBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  const WbAddBottomSheetBuild({super.key, required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    SrpAddBottomsheetFormModel form =
        context.read<SrpAddBottomsheetForm>().state;
    return BlocConsumer<SrpAddBottomsheetCubit, SrpAddBottomsheetState>(
      bloc: context.read<SrpAddBottomsheetCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == SrpAddBottomsheetState.loading) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else if (state == SrpAddBottomsheetState.load) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else {
          return wbAddBottomSheet(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == SrpAddBottomsheetState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessageQty ?? 'null',
                  ));
        }
        if (state == SrpAddBottomsheetState.save) {
          final SaleReportRowModel saleReportRow = SaleReportRowModel(
            product: form.product,
            customerName: form.customerCtrl.text,
            quantity: double.tryParse(form.qtyCtrl.text) ?? 0,
            unitPrice: double.tryParse(form.unitPriceCtrl.text) ?? 0,
          );
          Navigator.pop(
            context,
            saleReportRow,
          );
        }
      },
    );
  }

  Widget wbAddBottomSheet(
    BuildContext context,
    List<InventoryRowModel> inventoryList,
    SrpAddBottomsheetFormModel form,
  ) {
    final double heightScreen = MediaQuery.of(context).size.height;
    List<DropdownMenuItem<String>> itemList = [];
    DropdownMenuItem<String> item;
    final double subTotal;
    final double quantity;
    final double unitPrice;
    for (var element in inventoryList) {
      item = DropdownMenuItem(
        value: element.product.code,
        child: Text(
          '${element.product.code}: ${element.stock} ${element.product.description}',
          style: Typo.bodyDark,
          overflow: TextOverflow.visible,
        ),
      );
      itemList.add(item);
    }
    quantity = double.tryParse(form.qtyCtrl.text) ?? 0;
    unitPrice = double.tryParse(form.unitPriceCtrl.text) ?? 0;
    subTotal = quantity * unitPrice;
    return SizedBox(
      height: heightScreen * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.lightItems10),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Row(
                children: [
                  Expanded(
                    child: Visibility(
                        visible: form.product.code != '',
                        replacement: const SizedBox(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))),
                          context: context,
                          builder: (context) => SrpFindBottomsheet(
                              inventoryRowList: inventoryList),
                        ).then((value) {
                          if (value is InventoryRowModel) {
                            form.product = value.product;
                            form.stock = value.stock;
                            context.read<SrpAddBottomsheetCubit>().load(form);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: ColorPalette.lightItems10,
                      ))
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
                context.read<SrpAddBottomsheetCubit>().load(form);
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
                context.read<SrpAddBottomsheetCubit>().load(form);
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
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal: ', style: Typo.labelDark),
                Text(
                  '\$ ${FormatNumber.format2dec(subTotal)}',
                  style: Typo.labelDark,
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
                  context.read<SrpAddBottomsheetCubit>().save(form);
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
                        style: Typo.mobileLigth20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
