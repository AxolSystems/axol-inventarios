import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';
import '../model/product_model.dart';

class ProductDrawerDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return DrawerBox(
        header: const Text(
          'Detalles del producto',
          style: Typo.subtitleDark,
        ),
        actions: [
          ButtonReturnDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          rowDrawer('Clave: ', product.code),
          rowDrawer('Descripción: ', product.description),
          rowDrawer('Empaque: ', product.packing ?? ''),
          rowDrawer('Tipo: ', product.type ?? ''),
          rowDrawer('Capacidad: ', product.capacity ?? ''),
          rowDrawer('Medida: ', product.measure ?? ''),
          rowDrawer('Calibre: ',
              product.gauge == null ? '' : product.gauge.toString()),
          rowDrawer('Presentación: ', product.pieces ?? ''),
          rowDrawer('Peso: ',
              product.weight == null ? '' : product.weight.toString()),
        ]);
  }

  Widget rowDrawer(String key, String value) => Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              key,
              style: Typo.bodyDark,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Typo.bodyDark,
            ),
          ),
        ],
      );
}
