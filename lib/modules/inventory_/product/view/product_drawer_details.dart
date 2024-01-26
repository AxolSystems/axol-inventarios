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
          DrawerBox.rowKeyValue('Clave: ', product.code),
          DrawerBox.rowKeyValue('Descripción: ', product.description),
          DrawerBox.rowKeyValue('Empaque: ', product.packing ?? ''),
          DrawerBox.rowKeyValue('Tipo: ', product.type ?? ''),
          DrawerBox.rowKeyValue('Capacidad: ', product.capacity ?? ''),
          DrawerBox.rowKeyValue('Medida: ', product.measure ?? ''),
          DrawerBox.rowKeyValue('Calibre: ',
              product.gauge == null ? '' : product.gauge.toString()),
          DrawerBox.rowKeyValue('Presentación: ', product.pieces ?? ''),
          DrawerBox.rowKeyValue('Peso: ',
              product.weight == null ? '' : product.weight.toString()),
        ]);
  }
}
