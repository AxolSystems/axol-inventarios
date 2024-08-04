import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../cubit/inv_download_drawer/inv_download_drawer_cubit.dart';
import '../cubit/inv_download_drawer/inv_download_drawer_state.dart';
import '../model/inv_download_form_model.dart';

class InvDownloadDrawer extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  final WarehouseModel warehouse;
  const InvDownloadDrawer(
      {super.key, required this.inventoryRowList, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InvDownloadDrawerCubit()),
        BlocProvider(create: (_) => InvDownloadForm()),
      ],
      child: InvDownloadDrawerBuild(
          inventoryRowList: inventoryRowList, warehouse: warehouse),
    );
  }
}

class InvDownloadDrawerBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  final WarehouseModel warehouse;
  const InvDownloadDrawerBuild(
      {super.key, required this.inventoryRowList, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    InvDownloadFormModel form = context.read<InvDownloadForm>().state;
    return BlocConsumer<InvDownloadDrawerCubit, InvDownloadDrawerState>(
      bloc: context.read<InvDownloadDrawerCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingInvDownloadDrawerState) {
          return invDownloadDrawer(
              context, true, form, inventoryRowList, warehouse);
        } else if (state is LoadedInvDownloadDrawerState) {
          return invDownloadDrawer(
              context, false, form, inventoryRowList, warehouse);
        } else {
          return invDownloadDrawer(
              context, false, form, inventoryRowList, warehouse);
        }
      },
      listener: (context, state) {
        if (state is ErrorInvDownloadDrawerState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget invDownloadDrawer(
      BuildContext context,
      bool isLoading,
      InvDownloadFormModel form,
      List<InventoryRowModel> inventoryRowList,
      WarehouseModel warehouse) {
    final widthScreen = MediaQuery.of(context).size.width;
    return DrawerBox(
      width: widthScreen >= 600 ? 0.5 : 0.95,
      header: const Text(
        'Descarga de almacén',
        style: Typo.titleDark,
      ),
      actions: [
        SecondaryButtonDialog(
          text: 'Regresar',
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      children: [
        const Divider(color: ColorPalette.lightItems20),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Expanded(
                flex: 1,
                child: Text('Inventario', style: Typo.subtitleDark),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descuento de reporte de ventas',
                      style: Typo.systemDark,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 36,
                          child: SecondaryButtonDialog(
                            text: '',
                            border: const BorderSide(
                                color: ColorPalette.lightItems10),
                            icon: const Icon(
                              Icons.download,
                              color: ColorPalette.lightItems10,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context
                                        .read<InvDownloadDrawerCubit>()
                                        .csvSubSale(form.tfSubstract.text,
                                            inventoryRowList);
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                          controller: form.tfSubstract,
                          enabled: !isLoading,
                          /*inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
                          ],*/
                          style: Typo.bodyDark,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: ColorPalette.filled,
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.lightItems10),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            constraints:
                                BoxConstraints.tight(const Size.fromHeight(40)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.primary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Escriba el número de folio del reporte de ventas que quiera descontar del inventario actual.',
                      style: Typo.smallLabelDark,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 36,
                          child: SecondaryButtonDialog(
                            text: '',
                            border: const BorderSide(
                                color: ColorPalette.lightItems10),
                            icon: const Icon(
                              Icons.download,
                              color: ColorPalette.lightItems10,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context
                                        .read<InvDownloadDrawerCubit>()
                                        .csvInventory(
                                            warehouse, inventoryRowList);
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inventario actual', style: Typo.systemDark),
                              Text(
                                'Descarga en archivo csv el inventario del almacén actual.',
                                style: Typo.smallLabelDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(color: ColorPalette.lightItems20),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estado de inventario', style: Typo.subtitleDark),
                      SizedBox(
                        width: 84,
                        height: 36,
                        child: SecondaryButtonDialog(
                          text: 'CSV',
                          border: const BorderSide(
                              color: ColorPalette.lightItems10),
                          icon: const Icon(
                            Icons.download,
                            color: ColorPalette.lightItems10,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<InvDownloadDrawerCubit>()
                                      .csvInvToDate(warehouse, form);
                                },
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha',
                      style: Typo.systemDark,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: ColorPalette.lightItems10,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: ColorPalette.filled,
                              ),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: form.timeInventory,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now())
                                    .then((value) {
                                  if (value != null) {
                                    form.timeInventory =
                                        FormatDate.startDay(value);
                                    context
                                        .read<InvDownloadDrawerCubit>()
                                        .load();
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                        FormatDate.dmy(form.timeInventory),
                                        style: Typo.bodyDark),
                                  )),
                                  const Icon(
                                    Icons.calendar_month,
                                    color: ColorPalette.lightItems10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Seleccione la fecha del estado de inventario que desea descargar. La fecha seleccionada es considerada al principio del dia.',
                      style: Typo.smallLabelDark,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        'Omitir',
                        style: Typo.systemDark,
                      ),
                      TextField(
                        controller: form.tfOmit,
                        enabled: !isLoading,
                        style: Typo.bodyDark,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ColorPalette.filled,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorPalette.lightItems10),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(40)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette.primary),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Escriba los folios que quiera omitir en el descuento de movimientos para calcular el estado de inventario.',
                        style: Typo.smallLabelDark,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
