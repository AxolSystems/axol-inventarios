import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:flutter/material.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/text_label.dart';
import '../model/wb_add_form_model.dart';
import '../model/wb_bottomsheet_form_model.dart';
import 'wb_add_bottomsheet.dart';

class WbAddDetailsBottomsheet extends StatelessWidget {
  final WbAddFormModel form;
  final int index;
  final InventoryRowModel inventoryRow;
  const WbAddDetailsBottomsheet({
    super.key,
    required this.form,
    required this.index,
    required this.inventoryRow,
  });

  @override
  Widget build(BuildContext context) {
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
            const Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: AlertButtonDialog(
                    text: 'Eliminar',
                    onPressed: () {
                      form.waybillList.removeAt(index);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SecondaryButtonDialog(
                    text: 'Editar',
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12))),
                        context: context,
                        builder: (context) => WbAddBottomSheet(
                          inventoryList: form.inventoryList,
                          editRow: WbBottomSheetAddFormModel(
                            qtyCtrl: TextEditingController(
                                text: form.waybillList[index].stock.toString()),
                            errorMessage: null,
                            product: form.waybillList[index].product,
                            stock: inventoryRow.stock,
                          ),
                        ),
                      ).then((value) {
                        Navigator.pop(context, value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
