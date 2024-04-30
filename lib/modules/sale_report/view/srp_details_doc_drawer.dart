import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
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

class SrpDetailsDocDrawer extends StatelessWidget {
  final SaleReportModel saleReport;
  final UserModel user;
  const SrpDetailsDocDrawer(
      {super.key, required this.saleReport, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SrpDocDetailsCubit(),
      child: SrpDetailsDocDrawerBuild(saleReport: saleReport, user: user),
    );
  }
}

class SrpDetailsDocDrawerBuild extends StatelessWidget {
  final SaleReportModel saleReport;
  final UserModel user;
  const SrpDetailsDocDrawerBuild(
      {super.key, required this.saleReport, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SrpDocDetailsCubit, SrpDocDetailsState>(
      bloc: context.read<SrpDocDetailsCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSrpDocDetailsState) {
          return srpDetailsDocDrawer(
              context, true, saleReport, state.loadingState);
        } else if (state is LoadedSrpDocDetailsState) {
          return srpDetailsDocDrawer(context, false, saleReport);
        } else {
          return srpDetailsDocDrawer(context, false, saleReport);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget srpDetailsDocDrawer(
      BuildContext context, bool isLoading, SaleReportModel report,
      [LoadingSrpDocDetails? loading]) {
    final bool editVisible;
    final double widthScreen = MediaQuery.of(context).size.width;
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
    } else if (user.rol == UserModel.rolSup) {
      editVisible = false;
    } else {
      editVisible = true;
    }
    return DrawerBox(
      width: widthScreen < 600 ? 0.95 : 0.5,
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: ColorPalette.lightItems10))),
        child: Row(
          children: [
            Visibility(
                visible: widthScreen < 600,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: ColorPalette.darkItems,
                  ),
                )),
            Expanded(
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
          ],
        ),
      ),
      actions: [
        Expanded(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: ColorPalette.lightItems10))),
              child: Row(
                children: [
                  SecondaryButtonDialog(
                    text: 'Ver nota',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DrawerBox(
                          width: widthScreen < 600 ? 0.9 : 0.45,
                          header: widthScreen < 600 ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:[
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorPalette.darkItems,
                                ),
                              )
                            ],
                          ) : null,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorPalette.lightItems10),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: SingleChildScrollView(
                                  child:
                                      Text(report.note, style: Typo.bodyDark),
                                ),
                              ),
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
                                builder: (BuildContext context) =>
                                    SaleReportAdd(
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
        ))
      ],
      child: Expanded(
        child: ListView.builder(
          itemCount: report.reportRows.length,
          itemBuilder: (context, index) {
            final row = report.reportRows[index];
            final subtotal = row.quantity * row.unitPrice;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorPalette.lightItems20))),
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
                            Text(row.product.description, style: Typo.bodyDark),
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
                              const Text('Cliente', style: Typo.smallLabelDark),
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
    );
  }
}
