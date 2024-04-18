import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../cubit/inv_download_drawer/inv_download_drawer_cubit.dart';
import '../cubit/inv_download_drawer/inv_download_drawer_state.dart';
import '../model/inv_download_form_model.dart';

class InvDownloadDrawer extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const InvDownloadDrawer({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InvDownloadDrawerCubit()),
        BlocProvider(create: (_) => InvDownloadForm()),
      ],
      child: InvDownloadDrawerBuild(inventoryRowList: inventoryRowList),
    );
  }
}

class InvDownloadDrawerBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const InvDownloadDrawerBuild({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    InvDownloadFormModel form = context.read<InvDownloadForm>().state;
    return BlocConsumer<InvDownloadDrawerCubit, InvDownloadDrawerState>(
      bloc: context.read<InvDownloadDrawerCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingInvDownloadDrawerState) {
          return invDownloadDrawer(context, true, form, inventoryRowList);
        } else if (state is LoadedInvDownloadDrawerState) {
          return invDownloadDrawer(context, false, form, inventoryRowList);
        } else {
          return invDownloadDrawer(context, false, form, inventoryRowList);
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

  Widget invDownloadDrawer(BuildContext context, bool isLoading,
      InvDownloadFormModel form, List<InventoryRowModel> inventoryRowList) {
    return DrawerBox(
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
                child: Text('CSV', style: Typo.subtitleDark),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descuento de reporte de ventas',
                      style: Typo.labelDark,
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
                                    final id =
                                        int.tryParse(form.controller.text) ?? 0;
                                    context
                                        .read<InvDownloadDrawerCubit>()
                                        .csvSubSale(id, inventoryRowList);
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                          controller: form.controller,
                          enabled: !isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
                          ],
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
                    /*const SizedBox(height: 12),
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
                            onPressed: isLoading ? null : () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inventario actual', style: Typo.labelDark),
                              Text(
                                'Descarga en archivo csv el inventario del almacén actual.',
                                style: Typo.smallLabelDark,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(color: ColorPalette.lightItems20),
      ],
    );
  }
}
