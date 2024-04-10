import 'package:axol_inventarios/modules/waybill/view/wb_add_bottomsheet_find.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/wb_add/wb_add_bottomsheet_cubit.dart';
import '../model/wb_bottomsheet_form_model.dart';

class WbAddBottomSheet extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  const WbAddBottomSheet({super.key, required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddBottomSheetCubit()),
        BlocProvider(create: (_) => WbBottomSheetAddForm()),
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
    WbBottomSheetAddFormModel form = context.read<WbBottomSheetAddForm>().state;
    return BlocConsumer<WbAddBottomSheetCubit, WbAddBottomSheetState>(
      bloc: context.read<WbAddBottomSheetCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == WbAddBottomSheetState.loading) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else if (state == WbAddBottomSheetState.load) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else {
          return wbAddBottomSheet(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == WbAddBottomSheetState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? 'null',
                  ));
        }
        if (state == WbAddBottomSheetState.save) {
          final InventoryRowModel inventoryRow = InventoryRowModel(
            product: form.product,
            stock: double.parse(form.controller.text),
            warehouseName: inventoryList.first.warehouseName,
          );
          Navigator.pop(
            context,
            inventoryRow,
          );
        }
      },
    );
  }

  Widget wbAddBottomSheet(
    BuildContext context,
    List<InventoryRowModel> inventoryList,
    WbBottomSheetAddFormModel form,
  ) {
    final double heightScreen = MediaQuery.of(context).size.height;
    List<DropdownMenuItem<String>> itemList = [];
    DropdownMenuItem<String> item;
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
                          builder: (context) => WbAddBottomsheetFind(
                              inventoryRowList: inventoryList),
                        ).then((value) {
                          if (value is InventoryRowModel) {
                            form.product = value.product;
                            form.stock = value.stock;
                            context.read<WbAddBottomSheetCubit>().load(form);
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
              controller: form.controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Cantidad',
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                errorText: form.errorMessage,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
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
                  context.read<WbAddBottomSheetCubit>().save(form);
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
