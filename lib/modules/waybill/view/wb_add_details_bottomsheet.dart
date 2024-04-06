import 'package:flutter/material.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';

class WbAddDetailsBottomsheet extends StatelessWidget {
  final InventoryRowModel inventoryRow;
  final InventoryRowModel waybillRow;
  const WbAddDetailsBottomsheet({
    super.key,
    required this.inventoryRow, required this.waybillRow,
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
              'Clave: ${waybillRow.product.code}',
              style: Typo.bodyDark,
            ),
            const SizedBox(height: 8),
            Text(
              'Descripción: ${waybillRow.product.description}',
              style: Typo.bodyDark,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 8),
            Text(
              'Cantidad a llevar: ${waybillRow.stock}',
              style: Typo.bodyDark,
            ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${inventoryRow.stock}',
              style: Typo.bodyDark,
            ),
          ],
        ),
      ),
    );
  }
}
