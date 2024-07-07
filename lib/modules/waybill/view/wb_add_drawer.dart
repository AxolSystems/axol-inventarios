<<<<<<< HEAD
import 'package:axol_inventarios/modules/waybill/view/wb_add_bottomsheet_find.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../cubit/wb_add/wb_add_bottomsheet_cubit.dart';
import '../model/wb_bottomsheet_form_model.dart';

class WbAddDrawer extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final WbDrawerAddFormModel? editRow;
  final double? widthDrawer;
  const WbAddDrawer(
      {super.key, required this.inventoryList, this.editRow, this.widthDrawer});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddDrawerCubit()),
        BlocProvider(
            create: (_) => editRow == null
                ? WbDrawerAddForm()
                : WbDrawerAddForm.set(editRow!)),
      ],
      child: WbAddDrawerBuild(
        inventoryList: inventoryList,
        widthDrawer: widthDrawer,
      ),
    );
  }
}

class WbAddDrawerBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final double? widthDrawer;
  const WbAddDrawerBuild(
      {super.key, required this.inventoryList, this.widthDrawer});

  @override
  Widget build(BuildContext context) {
    WbDrawerAddFormModel form = context.read<WbDrawerAddForm>().state;
    return BlocConsumer<WbAddDrawerCubit, WbAddDrawerState>(
      bloc: context.read<WbAddDrawerCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == WbAddDrawerState.loading) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else if (state == WbAddDrawerState.load) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else {
          return wbAddBottomSheet(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == WbAddDrawerState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? 'null',
                  ));
        }
        if (state == WbAddDrawerState.save) {
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
    WbDrawerAddFormModel form,
  ) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return DrawerBox(
      width: widthScreen >= 600
          ? (0.5 - (widthDrawer ?? 0))
          : (0.95 - (widthDrawer ?? 0)),
      header: widthScreen < 600
          ? Row(
              children: [
                LeadingReturn(
                  color: ColorPalette.darkItems20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          : null,
      actions: widthScreen < 600
          ? [
              SizedBox(
                height: 50,
                width: ((widthScreen * (0.95 - (widthDrawer ?? 0))) - 8),
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  textStyle: Typo.mobileLight20,
                  onPressed: () {
                    context.read<WbAddDrawerCubit>().save(form);
                  },
                ),
              ),
            ]
          : [
              SizedBox(
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  onPressed: () {
                    context.read<WbAddDrawerCubit>().save(form);
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
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.all(8),
                  side: const BorderSide(color: ColorPalette.lightItems10)),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12))),
                  context: context,
                  builder: (context) =>
                      WbAddBottomsheetFind(inventoryRowList: inventoryList),
                ).then((value) {
                  if (value is InventoryRowModel) {
                    form.product = value.product;
                    form.stock = value.stock;
                    context.read<WbAddDrawerCubit>().load(form);
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
                                Flexible(
                                    child: Column(
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
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            const SizedBox(width: 8),
                          ],
                        )),
                  ),
                  const Icon(
                    Icons.search,
                    color: ColorPalette.lightItems10,
                  )
                ],
              )),
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
=======
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

class WbAddDrawer extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final WbDrawerAddFormModel? editRow;
  final double? widthDrawer;
  const WbAddDrawer(
      {super.key, required this.inventoryList, this.editRow, this.widthDrawer});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddDrawerCubit()),
        BlocProvider(
            create: (_) => editRow == null
                ? WbDrawerAddForm()
                : WbDrawerAddForm.set(editRow!)),
      ],
      child: WbAddDrawerBuild(
        inventoryList: inventoryList,
        widthDrawer: widthDrawer,
      ),
    );
  }
}

class WbAddDrawerBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  final double? widthDrawer;
  const WbAddDrawerBuild(
      {super.key, required this.inventoryList, this.widthDrawer});

  @override
  Widget build(BuildContext context) {
    WbDrawerAddFormModel form = context.read<WbDrawerAddForm>().state;
    return BlocConsumer<WbAddDrawerCubit, WbAddDrawerState>(
      bloc: context.read<WbAddDrawerCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == WbAddDrawerState.loading) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else if (state == WbAddDrawerState.load) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else {
          return wbAddBottomSheet(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == WbAddDrawerState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? 'null',
                  ));
        }
        if (state == WbAddDrawerState.save) {
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
    WbDrawerAddFormModel form,
  ) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return DrawerBox(
      width: widthScreen >= 600
          ? (0.5 - (widthDrawer ?? 0))
          : (0.95 - (widthDrawer ?? 0)),
      header: widthScreen < 600
          ? Row(
              children: [
                LeadingReturn(
                  color: ColorPalette.darkItems,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          : null,
      actions: widthScreen < 600
          ? [
              SizedBox(
                height: 50,
                width: ((widthScreen * (0.95 - (widthDrawer ?? 0))) - 8),
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  textStyle: Typo.mobileLigth20,
                  onPressed: () {
                    context.read<WbAddDrawerCubit>().save(form);
                  },
                ),
              ),
            ]
          : [
              SizedBox(
                child: PrimaryButtonDialog(
                  text: 'Guardar',
                  onPressed: () {
                    context.read<WbAddDrawerCubit>().save(form);
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
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.all(8),
                  side: const BorderSide(color: ColorPalette.lightItems10)),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12))),
                  context: context,
                  builder: (context) =>
                      WbAddBottomsheetFind(inventoryRowList: inventoryList),
                ).then((value) {
                  if (value is InventoryRowModel) {
                    form.product = value.product;
                    form.stock = value.stock;
                    context.read<WbAddDrawerCubit>().load(form);
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
                                Flexible(
                                    child: Column(
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
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            const SizedBox(width: 8),
                          ],
                        )),
                  ),
                  const Icon(
                    Icons.search,
                    color: ColorPalette.lightItems10,
                  )
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            style: Typo.bodyDark,
            controller: form.qtyCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
>>>>>>> main
