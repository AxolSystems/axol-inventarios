import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../cubit/add/srp_add_state.dart';
import '../cubit/doc_details/srp_doc_details_cubit.dart';
import '../cubit/doc_details/srp_doc_details_state.dart';
import '../model/salereport_model.dart';
import 'salereport_add.dart';

class SrpDetailsDocBottomsheet extends StatelessWidget {
  final SaleReportModel saleReport;
  final UserModel user;
  const SrpDetailsDocBottomsheet({super.key, required this.saleReport, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SrpDocDetailsCubit(),
      child: SrpDetailsDocBottomSheetBuild(saleReport: saleReport, user: user),
    );
  }
}

class SrpDetailsDocBottomSheetBuild extends StatelessWidget {
  final SaleReportModel saleReport;
  final UserModel user;
  const SrpDetailsDocBottomSheetBuild({super.key, required this.saleReport, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SrpDocDetailsCubit, SrpDocDetailsState>(
      bloc: context.read<SrpDocDetailsCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSrpDocDetailsState) {
          return srpDetailsDocBottomsheet(
              context, true, saleReport, state.loadingState);
        } else if (state is LoadedSrpDocDetailsState) {
          return srpDetailsDocBottomsheet(context, false, saleReport);
        } else {
          return srpDetailsDocBottomsheet(context, false, saleReport);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget srpDetailsDocBottomsheet(
      BuildContext context, bool isLoading, SaleReportModel report,
      [LoadingSrpDocDetails? loading]) {
    final bool editVisible;
    final double heightScreen = MediaQuery.of(context).size.height;
    double total = 0;
    for (var row in report.reportRows) {
      total = total + (row.quantity * row.unitPrice);
    }
    if (user.rol == UserModel.rolVendor) {
      final limitTime = report.date.add(const Duration(hours: 24));
      if (limitTime.isAfter(DateTime.now())) {
        editVisible = true;
      } else {
        editVisible = false;
      }
    } else {
      editVisible = true;
    }
    return SizedBox(
      height: heightScreen * 0.9,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorPalette.lightItems10))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text('Id', style: Typo.smallLabelDark),
                            Text(report.id.toString(), style: Typo.bodyDark),
                          ],
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            const Text('Almacén', style: Typo.smallLabelDark),
                            Text(
                                '${report.warehouse.id} - ${report.warehouse.name}')
                          ],
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const Text('Fecha', style: Typo.smallLabelDark),
                            Text(FormatDate.dmy(report.date),
                                style: Typo.bodyDark),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: report.reportRows.length,
              itemBuilder: (context, index) {
                final row = report.reportRows[index];
                final subtotal = row.quantity * row.unitPrice;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: ColorPalette.lightItems20))),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const Text('Clave', style: Typo.smallLabelDark),
                                Text(row.product.code, style: Typo.bodyDark),
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                const Text('Descripción',
                                    style: Typo.smallLabelDark),
                                Text(row.product.description,
                                    style: Typo.bodyDark),
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            const Text('Cantidad', style: Typo.smallLabelDark),
                            Text(FormatNumber.format2dec(row.quantity),
                                style: Typo.bodyDark),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            const Text('Precio unitario',
                                style: Typo.smallLabelDark),
                            Text('\$ ${FormatNumber.format2dec(row.unitPrice)}',
                                style: Typo.bodyDark),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            const Text('Subtotal', style: Typo.smallLabelDark),
                            Text('\$ ${FormatNumber.format2dec(subtotal)}',
                                style: Typo.bodyDark),
                          ],
                        ))
                      ],
                    ),
                    Visibility(
                        visible: row.customerName != '',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const Text('Cliente',
                                      style: Typo.smallLabelDark),
                                  Text(row.customerName, style: Typo.bodyDark),
                                ],
                              )
                            ],
                          ),
                        )),
                  ]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: ColorPalette.lightItems10))),
            child: Row(
              children: [
                SecondaryButtonDialog(
                  text: 'Ver nota',
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12))),
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorPalette.lightItems10),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(report.note, style: Typo.bodyDark),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text('Total: ', style: Typo.labelDark),
                const Expanded(child: SizedBox()),
                Text(
                  '\$ ${FormatNumber.format2dec(total)}',
                  style: Typo.labelDark,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: SecondaryButtonDialog(
                      text: 'Descargar PDF',
                      onPressed: null,
                      loadingState: loading == LoadingSrpDocDetails.downPdf,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: SizedBox(
                  height: 40,
                  child: SecondaryButtonDialog(
                    text: 'Descargar CSV',
                    loadingState: loading == LoadingSrpDocDetails.downCsv,
                    onPressed: isLoading
                        ? null
                        : () {
                            context
                                .read<SrpDocDetailsCubit>()
                                .saveCsv(saleReport);
                          },
                  ),
                )),
              ],
            ),
          ),
          Visibility(
            visible: editVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: SecondaryButtonDialog(
                  text: 'Editar',
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SaleReportAdd(
                                warehouse: report.warehouse,
                                subState: SrpAddSubState.edit,
                                reportEdit: report,
                              ),
                            ),
                          );
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
