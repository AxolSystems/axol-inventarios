import 'package:axol_inventarios/models/inventory_row_model.dart';
import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../model/wb_add_form_model.dart';

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
            Text(
              'Clave: ${form.waybillList[index].product.code}',
              style: Typo.bodyDark,
            ),
            const SizedBox(height: 8),
            Text(
              'Descripción: ${form.waybillList[index].product.description}',
              style: Typo.bodyDark,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 8),
            Text(
              'Cantidad a llevar: ${form.waybillList[index].stock}',
              style: Typo.bodyDark,
            ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${inventoryRow.stock}',
              style: Typo.bodyDark,
            ),
            const Expanded(child: SizedBox()),
            AlertButtonDialog(
              text: 'Eliminar',
              onPressed: () {
                form.waybillList.removeAt(index);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
