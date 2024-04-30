import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../../../utilities/widgets/text_label.dart';
import '../model/salereport_row_model.dart';
import '../model/srp_add_form_model.dart';
import 'srp_add_row_drawer.dart';

class SrpDetailsRowDrawer extends StatelessWidget {
  final SaleReportRowModel row;
  final int index;
  final SrpAddFormModel form;
  const SrpDetailsRowDrawer({
    super.key,
    required this.row,
    required this.index,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = row.quantity * row.unitPrice;
    final double widthScreen = MediaQuery.of(context).size.width;
    return DrawerBox(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      width: widthScreen >= 600 ? 0.5 : 0.95,
      header: Visibility(
        visible: widthScreen < 600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorPalette.darkItems,
                )),
          ],
        ),
      ),
      actions: widthScreen >= 600
          ? [
              AlertButtonDialog(
                text: 'Eliminar',
                onPressed: () {
                  form.saleReportList.removeAt(index);
                  Navigator.pop(context);
                },
              ),
              SecondaryButtonDialog(
                text: 'Editar',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SrpAddRowDrawer(
                      inventoryList: form.inventoryList,
                      rowEdit: row,
                    ),
                  ).then((value) {
                    if (value != null) {
                      Navigator.pop(context, value);
                    }
                  });
                },
              ),
              SecondaryButtonDialog(
                text: 'Regresar',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]
          : [
              SizedBox(
                width: ((widthScreen * 0.95) / 2) - 16,
                height: 40,
                child: AlertButtonDialog(
                  text: 'Eliminar',
                  textStyle: Typo.mobileLigth18,
                  onPressed: () {
                    form.saleReportList.removeAt(index);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: ((widthScreen * 0.95) / 2) - 16,
                height: 40,
                child: SecondaryButtonDialog(
                  text: 'Editar',
                  textStyle: Typo.mobileDark18,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SrpAddRowDrawer(
                        inventoryList: form.inventoryList,
                        rowEdit: row,
                      ),
                    ).then((value) {
                      if (value != null) {
                        Navigator.pop(context, value);
                      }
                    });
                  },
                ),
              )
            ],
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
      ],
    );
  }
}
