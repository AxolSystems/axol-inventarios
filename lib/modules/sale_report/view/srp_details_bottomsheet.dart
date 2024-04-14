import 'package:flutter/material.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/text_label.dart';
import '../model/salereport_row_model.dart';
import '../model/srp_add_form_model.dart';

class SrpDetailsBottomsheet extends StatelessWidget {
  final SaleReportRowModel row;
  final int index;
  final SrpAddFormModel form;
  const SrpDetailsBottomsheet({
    super.key,
    required this.row,
    required this.index,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = row.quantity * row.unitPrice;
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextLabel(
                    label: 'Clave',
                    text: row.product.code,
                    labelStyle: Typo.smallLabelDark,
                    textStyle: Typo.bodyDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextLabel(
                    label: 'Descripción',
                    text: row.product.description,
                    labelStyle: Typo.smallLabelDark,
                    textStyle: Typo.bodyDark,
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
                      labelStyle: Typo.smallLabelDark,
                      textStyle: Typo.bodyDark,
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
                    labelStyle: Typo.smallLabelDark,
                    textStyle: Typo.bodyDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextLabel(
                    text: '\$ ${FormatNumber.format2dec(row.unitPrice)}',
                    label: 'Precio unitario',
                    labelStyle: Typo.smallLabelDark,
                    textStyle: Typo.bodyDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    flex: 2,
                    child: TextLabel(
                      text: '\$ ${FormatNumber.format2dec(subtotal)}',
                      label: 'Subtotal',
                      labelStyle: Typo.smallLabelDark,
                      textStyle: Typo.bodyDark,
                    )),
              ],
            ),
            const Expanded(child: SizedBox()),
            AlertButtonDialog(
              text: 'Eliminar',
              onPressed: () {
                form.saleReportList.removeAt(index);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
