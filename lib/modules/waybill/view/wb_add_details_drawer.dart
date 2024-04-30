import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/text_label.dart';
import '../model/wb_add_form_model.dart';
import '../model/wb_bottomsheet_form_model.dart';
import 'wb_add_drawer.dart';

class WbAddDetailsDrawer extends StatelessWidget {
  final WbAddFormModel form;
  final int index;
  final InventoryRowModel inventoryRow;
  const WbAddDetailsDrawer({
    super.key,
    required this.form,
    required this.index,
    required this.inventoryRow,
  });

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return DrawerBox(
      width: widthScreen >= 600 ? 0.5 : 0.95,
      padding: const EdgeInsets.all(4),
      header: widthScreen < 600
          ? const Row(
              children: [LeadingReturn(color: ColorPalette.darkItems)],
            )
          : null,
      actions: widthScreen >= 600
          ? [
              AlertButtonDialog(
                text: 'Eliminar',
                onPressed: () {
                  form.waybillList.removeAt(index);
                  Navigator.pop(context);
                },
              ),
              SecondaryButtonDialog(
                text: 'Editar',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => WbAddDrawer(
                      widthDrawer: 0.05,
                      inventoryList: form.inventoryList,
                      editRow: WbDrawerAddFormModel(
                        qtyCtrl: TextEditingController(
                            text: form.waybillList[index].stock.toString()),
                        errorMessage: null,
                        product: form.waybillList[index].product,
                        stock: inventoryRow.stock,
                      ),
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
              Expanded(
                child: SizedBox(
                  width: ((widthScreen * 0.95) / 2) - 16,
                  height: 40,
                  child: AlertButtonDialog(
                    text: 'Eliminar',
                    textStyle: Typo.mobileLigth18,
                    onPressed: () {
                      form.waybillList.removeAt(index);
                      Navigator.pop(context);
                    },
                  ),
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
                      builder: (context) => WbAddDrawer(
                        widthDrawer: 0.05,
                        inventoryList: form.inventoryList,
                        editRow: WbDrawerAddFormModel(
                          qtyCtrl: TextEditingController(
                              text: form.waybillList[index].stock.toString()),
                          errorMessage: null,
                          product: form.waybillList[index].product,
                          stock: inventoryRow.stock,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        Navigator.pop(context, value);
                      }
                    });
                  },
                ),
              ),
            ],
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextLabel(
                label: 'Clave',
                text: form.waybillList[index].product.code,
                labelStyle: Typo.smallLabelDark,
                textStyle: Typo.bodyDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: TextLabel(
                label: 'Descripción',
                text: form.waybillList[index].product.description,
                labelStyle: Typo.smallLabelDark,
                textStyle: Typo.bodyDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
                child: TextLabel(
              label: 'Cant. transportación',
              text: FormatNumber.format2dec(form.waybillList[index].stock),
              labelStyle: Typo.smallLabelDark,
              textStyle: Typo.bodyDark,
            )),
            const SizedBox(width: 8),
            Expanded(
                child: TextLabel(
              label: 'Stock almacén',
              text: FormatNumber.format2dec(inventoryRow.stock),
              labelStyle: Typo.smallLabelDark,
              textStyle: Typo.bodyDark,
            ))
          ],
        ),
      ],
    );
  }
}
