import 'package:axol_inventarios/modules/waybill/view/wb_add_bottomsheet_find.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../cubit/wb_add/wb_add_bottomsheet_cubit.dart';
import '../model/wb_bottomsheet_form_model.dart';

class WbAddBottomSheet extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final WbBottomSheetAddFormModel? editRow;
  const WbAddBottomSheet(
      {super.key, required this.inventoryList, this.editRow});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddBottomSheetCubit()),
        BlocProvider(
            create: (_) => editRow == null
                ? WbBottomSheetAddForm()
                : WbBottomSheetAddForm.set(editRow!)),
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
            stock: double.parse(form.qtyCtrl.text),
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
    final double widthScreen = MediaQuery.of(context).size.width;
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
    return DrawerBox(
      width: widthScreen >= 600 ? 0.5 : 0.95,
      header: widthScreen < 600
          ? const Row(
              children: [
                LeadingReturn(
                  color: ColorPalette.darkItems,
                )
              ],
            )
          : null,
      actions: widthScreen < 600
          ? [
              SizedBox(
                height: 50,
                width: ((widthScreen * 0.95) - 8),
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  onPressed: () {
                    context.read<WbAddBottomSheetCubit>().save(form);
                  },
                ),
              ),
            ]
          : [
              SizedBox(
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  onPressed: () {
                    context.read<WbAddBottomSheetCubit>().save(form);
                  },
                ),
              ),
              SecondaryButtonDialog(
                text: 'Regresar',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
      children: [
        //Column(
        // children: [
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
            controller: form.qtyCtrl,
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
        //const Expanded(child: SizedBox()),
      ],
      //],
      //),
    );
  }
}
