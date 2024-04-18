import 'package:axol_inventarios/modules/sale_report/view/srp_add_drawer.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/text_label.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/add/srp_add_cubit.dart';
import '../cubit/add/srp_add_state.dart';
import '../model/salereport_row_model.dart';
import '../model/srp_add_form_model.dart';
import 'srp_add_bottomsheet.dart';
import 'srp_details_row_bottomsheet.dart';

class SaleReportAdd extends StatelessWidget {
  final WarehouseModel warehouse;
  const SaleReportAdd({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpAddCubit()),
        BlocProvider(create: (_) => SrpAddForm()),
      ],
      child: SaleReportAddBuild(
        warehouse: warehouse,
      ),
    );
  }
}

class SaleReportAddBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const SaleReportAddBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    SrpAddFormModel form = context.read<SrpAddForm>().state;
    return BlocConsumer<SrpAddCubit, SrpAddState>(
      bloc: context.read<SrpAddCubit>()..initLoad(warehouse, form),
      builder: (context, state) {
        if (state is LoadingSrpAddState) {
          return srpAdd(context, true, form);
        } else if (state is LoadedSrpAddState) {
          return srpAdd(context, false, form);
        } else {
          return srpAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorSrpAddState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
        if (state is SavedSrpAddState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget srpAdd(BuildContext context, bool isLoading, SrpAddFormModel form) {
    //final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol.appBar(
        title: 'Nuevo reporte',
        isLoading: isLoading,
        leading: const LeadingReturn(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              color: ColorPalette.darkItems,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Almacén: ${warehouse.id} - ${warehouse.name}',
                    style: Typo.subtitleLight,
                    overflow: TextOverflow.fade,
                  ),
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: form.dateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          form.dateTime = value;
                          context.read<SrpAddCubit>().load();
                        }
                      });
                    },
                    child: Text(
                      FormatDate.dmy(form.dateTime),
                      style: Typo.subtitleLight,
                    ),
                  ),
                ],
              )),
          Visibility(
            visible: !isLoading,
            replacement: const Expanded(child: SizedBox()),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: form.saleReportList.length,
                itemBuilder: (context, index) {
                  final row = form.saleReportList[index];
                  final subtotal = row.quantity * row.unitPrice;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorPalette.darkItems),
                      ),
                    ),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: BorderSide.none),
                        onPressed: () {},
                        onLongPress: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12))),
                            context: context,
                            builder: (context) => SrpDetailsRowBottomsheet(
                              row: row,
                              form: form,
                              index: index,
                            ),
                          ).then((value) {
                            context.read<SrpAddCubit>().load();
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextLabel(
                                    label: 'Clave',
                                    text: row.product.code,
                                    labelStyle: Typo.smallLabelLight,
                                    textStyle: Typo.bodyLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 3,
                                  child: TextLabel(
                                    label: 'Descripción',
                                    text: row.product.description,
                                    labelStyle: Typo.smallLabelLight,
                                    textStyle: Typo.bodyLight,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: row.customerName != '' ? 8 : 0),
                                Visibility(
                                  visible: row.customerName != '',
                                  child: Expanded(
                                    flex: 2,
                                    child: TextLabel(
                                      label: 'Cliente',
                                      text: row.customerName,
                                      labelStyle: Typo.smallLabelLight,
                                      textStyle: Typo.bodyLight,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextLabel(
                                    text: row.quantity.toString(),
                                    label: 'Cantidad',
                                    labelStyle: Typo.smallLabelLight,
                                    textStyle: Typo.bodyLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextLabel(
                                    text:
                                        '\$ ${FormatNumber.format2dec(row.unitPrice)}',
                                    label: 'Precio unitario',
                                    labelStyle: Typo.smallLabelLight,
                                    textStyle: Typo.bodyLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    flex: 2,
                                    child: TextLabel(
                                      text:
                                          '\$ ${FormatNumber.format2dec(subtotal)}',
                                      label: 'Subtotal',
                                      labelStyle: Typo.smallLabelLight,
                                      textStyle: Typo.bodyLight,
                                    )),
                              ],
                            )
                          ],
                        )),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: form.note,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorPalette.lightItems10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorPalette.primary, width: 2)),
                    label: Text(
                      'Nota',
                      style: Typo.labelLight,
                    )),
                style: Typo.bodyLight,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: ColorPalette.lightItems10),
                        ),
                        onPressed: !isLoading
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogAxol(
                                          text:
                                              '¿Desea guardar los datos actuales?',
                                          actions: [
                                            SecondaryButtonDialog(
                                              text: 'Cancelar',
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            ),
                                            PrimaryButtonDialog(
                                              text: 'Guardar',
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          ],
                                        )).then((value) {
                                  if (value == true) {
                                    context.read<SrpAddCubit>().save(form);
                                  }
                                });
                              }
                            : null,
                        child: const Icon(
                          Icons.save,
                          color: ColorPalette.lightItems10,
                          size: 26,
                        )),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
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
                      onPressed: !isLoading
                          ? () {
                              /*if (widthScreen < 600) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12))),
                                  context: context,
                                  builder: (context) => SrpAddBottomsheet(
                                      inventoryList: form.inventoryList),
                                ).then((value) {
                                  if (value is SaleReportRowModel) {
                                    form.saleReportList.add(value);
                                    context.read<SrpAddCubit>().load();
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => SrpAddDrawer(
                                          inventoryList: form.inventoryList,
                                        )).then((value) {
                                  if (value is SaleReportRowModel) {
                                    form.saleReportList.add(value);
                                    context.read<SrpAddCubit>().load();
                                  }
                                });
                              }*/
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12))),
                                context: context,
                                builder: (context) => SrpAddBottomsheet(
                                    inventoryList: form.inventoryList),
                              ).then((value) {
                                if (value is SaleReportRowModel) {
                                  form.saleReportList.add(value);
                                  context.read<SrpAddCubit>().load();
                                }
                              });
                            }
                          : null,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.add,
                              color: ColorPalette.lightBackground,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Agregar',
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
          ),
        ],
      ),
    );
  }
}
