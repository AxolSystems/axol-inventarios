import 'package:flutter/material.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../model/waybill_list_model.dart';

class WbListDetailsBottomsheet extends StatelessWidget {
  final WaybillListModel waybill;
  const WbListDetailsBottomsheet({super.key, required this.waybill});

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
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
          ],
        ),
      ),
    );
  }
}
