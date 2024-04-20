import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../sale_report/cubit/doc_details/srp_doc_details_state.dart';
import '../cubit/list_details/wb_list_details_cubit.dart';
import '../cubit/list_details/wb_list_details_state.dart';
import '../model/waybill_list_model.dart';
import 'wb_add_list.dart';

class WbListDetailsBottomsheet extends StatelessWidget {
  final WaybillListModel waybill;
  const WbListDetailsBottomsheet({super.key, required this.waybill});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WbListDetailsCubit(),
      child: WbListDetailsBottomsheetBuild(waybill: waybill),
    );
  }
}

class WbListDetailsBottomsheetBuild extends StatelessWidget {
  final WaybillListModel waybill;
  const WbListDetailsBottomsheetBuild({super.key, required this.waybill});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WbListDetailsCubit, WbListDetailsState>(
      builder: (context, state) {
        if (state is LoadingWbListDetailsState) {
          return wbLisDetailsBottomsheet(context, true, state.loadingState);
        } else if (state is LoadedWbListDetailsState) {
          return wbLisDetailsBottomsheet(context, false);
        } else {
          return wbLisDetailsBottomsheet(context, false);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget wbLisDetailsBottomsheet(BuildContext context, bool isLoading,
      [LoadingWbListDetails? loading]) {
    final double heightScreen = MediaQuery.of(context).size.height;
    double totalPrice = 0;
    double totalWeight = 0;

    for (var element in waybill.list) {
      totalPrice = totalPrice +
          (element.product.price *
              element.stock *
              (element.product.weight ?? 0));
    }

    return SizedBox(
      height: heightScreen * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: ColorPalette.lightItems10),
              )),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Id',
                          style: Typo.smallLabelDark,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Almacén',
                          style: Typo.smallLabelDark,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Fecha',
                          style: Typo.smallLabelDark,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          waybill.id.toString(),
                          style: Typo.bodyDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          waybill.warehouse.name,
                          style: Typo.bodyDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          FormatDate.dmy(waybill.date),
                          style: Typo.bodyDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: waybill.list.length,
                itemBuilder: (context, index) {
                  final row = waybill.list[index];
                  final totalWeight = (row.product.weight ?? 0) * row.stock;
                  final totalPrice =
                      row.product.price * (row.product.weight ?? 0) * row.stock;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: ColorPalette.lightItems20))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Clave',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    row.product.code,
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Descripción',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    row.product.description,
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cantidad',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    FormatNumber.format2dec(row.stock),
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Peso unitario',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    '${row.product.weight} KG',
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Valor unitario',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    '\$ ${row.product.price}',
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Peso total',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    '${FormatNumber.format2dec(totalWeight)} KG',
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Valor total',
                                    style: Typo.smallLabelDark,
                                  ),
                                  Text(
                                    '\$ ${FormatNumber.format2dec(totalPrice)}',
                                    style: Typo.bodyDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: ColorPalette.lightItems10))),
              child: Row(
                children: [
                  const Text('Total: ', style: Typo.labelDark),
                  const Expanded(child: SizedBox()),
                  /*Text(
                    '\$ ${FormatNumber.format2dec(total)}',
                    style: Typo.labelDark,
                  ),*/ //Campio temporal
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
                        loadingState: loading == LoadingWbListDetails.downPdf,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: SizedBox(
                    height: 40,
                    child: SecondaryButtonDialog(
                      text: 'Descargar CSV',
                      loadingState: loading == LoadingWbListDetails.downCsv,
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<WbListDetailsCubit>()
                                  .saveCsv(waybill.list);
                            },
                    ),
                  )),
                ],
              ),
            ),
            Visibility(
              visible: true, //Cambio temporal
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
                                builder: (BuildContext context) => WbAddList(
                                  warehouse: waybill.warehouse,
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
      ),
    );
  }
}
