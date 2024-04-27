import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/widgets/navigation_rail/navigation_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/table_view/table_view.dart';
import '../../../utilities/widgets/text_label.dart';
import '../../../utilities/widgets/toolbar.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/add/srp_add_cubit.dart';
import '../cubit/add/srp_add_state.dart';
import '../model/salereport_model.dart';
import '../model/salereport_row_model.dart';
import '../model/srp_add_form_model.dart';
import 'srp_add_bottomsheet.dart';
import 'srp_details_row_bottomsheet.dart';

class SaleReportAdd extends StatelessWidget {
  final WarehouseModel warehouse;
  final SrpAddSubState subState;
  final SaleReportModel? reportEdit;

  const SaleReportAdd(
      {super.key,
      required this.warehouse,
      required this.subState,
      this.reportEdit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpAddCubit()),
        BlocProvider(create: (_) => SrpAddForm()),
      ],
      child: SaleReportAddBuild(
        warehouse: warehouse,
        subState: subState,
        reportEdit: reportEdit,
      ),
    );
  }
}

class SaleReportAddBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  final SrpAddSubState subState;
  final SaleReportModel? reportEdit;

  const SaleReportAddBuild(
      {super.key,
      required this.warehouse,
      required this.subState,
      this.reportEdit});

  @override
  Widget build(BuildContext context) {
    SrpAddFormModel form = context.read<SrpAddForm>().state;

    return BlocConsumer<SrpAddCubit, SrpAddState>(
      bloc: context.read<SrpAddCubit>()
        ..initLoad(warehouse, form, subState, reportEdit),
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
          if (subState == SrpAddSubState.add) {
            Navigator.pop(context);
          } else if (subState == SrpAddSubState.edit) {
            Navigator.pop(context);
            Navigator.pop(context, subState);
          }
        }
      },
    );
  }

  Widget srpAdd(BuildContext context, bool isLoading, SrpAddFormModel form) {
    final widthScreen = MediaQuery.of(context).size.width;
    final String title;
    double total = 0;

    if (subState == SrpAddSubState.edit) {
      title = 'Editar report';
    } else {
      title = 'Nuevo reporte';
    }

    for (var element in form.saleReportList) {
      total = total + (element.quantity * element.unitPrice);
    }
    return Scaffold(
        backgroundColor: ColorPalette.darkBackground,
        appBar: AppBarAxol.appBar(
          title: title,
          isLoading: isLoading,
          leading: widthScreen < 600 ? const LeadingReturn() : null,
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widthScreen >= 600,
              child: NavigationUtilities.emptyNavRailReturn(),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(color: ColorPalette.darkItems))),
                child: Column(
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
                            onPressed: subState == SrpAddSubState.edit
                                ? null
                                : () {
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
                      ),
                    ),
                    Visibility(
                      visible: widthScreen >= 600,
                      child: HeaderTable(
                        dataList: [
                          DataTableAxol.text('Clave'),
                          DataTableAxol(text: 'Descripción', flex: 2),
                          DataTableAxol.text('Cantidad'),
                          DataTableAxol.text('Precio unitario'),
                          DataTableAxol.text('Subtotal'),
                          DataTableAxol.text('Cliente'),
                          DataTableAxol.space(50),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !isLoading,
                                  replacement:
                                      const Expanded(child: SizedBox()),
                                  child: Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: form.saleReportList.length,
                                      itemBuilder: (context, index) {
                                        final row = form.saleReportList[index];
                                        final subtotal =
                                            row.quantity * row.unitPrice;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      ColorPalette.darkItems),
                                            ),
                                          ),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: BorderSide.none),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        12))),
                                                context: context,
                                                builder: (context) =>
                                                    SrpDetailsRowBottomsheet(
                                                  row: row,
                                                  form: form,
                                                  index: index,
                                                ),
                                              ).then((value) {
                                                if (value
                                                    is SaleReportRowModel) {
                                                  form.saleReportList[index] =
                                                      value;
                                                  context
                                                      .read<SrpAddCubit>()
                                                      .load();
                                                }
                                              });
                                            },
                                            child: widthScreen < 600
                                                ? SaleReportAddWidgets
                                                    .buttonRowMobile(
                                                        row, subtotal)
                                                : SaleReportAddWidgets
                                                    .buttonRowDesktop(
                                                        row, subtotal),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Visibility(
                                    visible: widthScreen < 600,
                                    replacement: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            'Total:  \$ ${FormatNumber.format2dec(total)}',
                                            style: Typo.labelLight)
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Total: ',
                                            style: Typo.labelLight),
                                        Text(
                                            '\$ ${FormatNumber.format2dec(total)}',
                                            style: Typo.labelLight)
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                      controller: form.note,
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorPalette
                                                      .lightItems10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorPalette.primary,
                                                  width: 2)),
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
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widthScreen >= 600,
                            child: HorizontalToolBar(
                              border: const Border(
                                left: BorderSide(color: ColorPalette.darkItems),
                              ),
                              children: [
                                ButtonTool(
                                  icon: Icons.add,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12))),
                                            context: context,
                                            builder: (context) =>
                                                SrpAddBottomsheet(
                                                    inventoryList:
                                                        form.inventoryList),
                                          ).then((value) {
                                            if (value is SaleReportRowModel) {
                                              form.saleReportList.add(value);
                                              context
                                                  .read<SrpAddCubit>()
                                                  .load();
                                            }
                                          });
                                        },
                                ),
                                ButtonTool(
                                  icon: Icons.save,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialogAxol(
                                                    text:
                                                        '¿Desea guardar los datos actuales?',
                                                    actions: [
                                                      SecondaryButtonDialog(
                                                        text: 'Cancelar',
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      ),
                                                      PrimaryButtonDialog(
                                                        text: 'Guardar',
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        },
                                                      ),
                                                    ],
                                                  )).then((value) {
                                            if (value == true) {
                                              context.read<SrpAddCubit>().save(
                                                  form, subState, reportEdit);
                                            }
                                          });
                                        },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widthScreen < 600,
                      child: Padding(
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
                                                builder: (context) =>
                                                    AlertDialogAxol(
                                                      text:
                                                          '¿Desea guardar los datos actuales?',
                                                      actions: [
                                                        SecondaryButtonDialog(
                                                          text: 'Cancelar',
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, false);
                                                          },
                                                        ),
                                                        PrimaryButtonDialog(
                                                          text: 'Guardar',
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, true);
                                                          },
                                                        ),
                                                      ],
                                                    )).then((value) {
                                              if (value == true) {
                                                context
                                                    .read<SrpAddCubit>()
                                                    .save(form, subState,
                                                        reportEdit);
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
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12))),
                                            context: context,
                                            builder: (context) =>
                                                SrpAddBottomsheet(
                                                    inventoryList:
                                                        form.inventoryList),
                                          ).then((value) {
                                            if (value is SaleReportRowModel) {
                                              form.saleReportList.add(value);
                                              context
                                                  .read<SrpAddCubit>()
                                                  .load();
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
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class SaleReportAddWidgets {
  static Widget buttonRowMobile(SaleReportRowModel row, double subtotal) =>
      Column(
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
                  text: '\$ ${FormatNumber.format2dec(row.unitPrice)}',
                  label: 'Precio unitario',
                  labelStyle: Typo.smallLabelLight,
                  textStyle: Typo.bodyLight,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: TextLabel(
                    text: '\$ ${FormatNumber.format2dec(subtotal)}',
                    label: 'Subtotal',
                    labelStyle: Typo.smallLabelLight,
                    textStyle: Typo.bodyLight,
                  )),
            ],
          )
        ],
      );

  static Widget buttonRowDesktop(SaleReportRowModel row, double subtotal) =>
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              row.product.code,
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              row.product.description,
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              FormatNumber.format2dec(row.quantity),
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$ ${FormatNumber.format2dec(row.unitPrice)}',
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$ ${FormatNumber.format2dec(subtotal)}',
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              row.customerName,
              style: Typo.bodyLight,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
