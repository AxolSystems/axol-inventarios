import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../models/inventory_row_model.dart';
import '../../../../../../utilities/theme/theme.dart';

class ListviewFindProduct extends StatelessWidget {
  final List<InventoryRowModel>? inventoryList;
  final List<ProductModel>? productList;
  final bool isWithStock;

  const ListviewFindProduct(
      {super.key, this.inventoryList, required this.isWithStock, this.productList});

  @override
  Widget build(BuildContext context) {
    if (isWithStock) {
      return Expanded(
          child: ListView.builder(
        itemCount: inventoryList!.length,
        itemBuilder: (context, index) {
          final elementList = inventoryList![index];
          return SizedBox(
            height: 40,
            child: OutlinedButton(
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll<Color>(
                      ColorPalette.overlayButton)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(elementList.product.code,
                            style: Typo.bodyDark),
                      )),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(elementList.product.description,
                            style: Typo.bodyDark),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(elementList.stock.toString(),
                            style: Typo.bodyDark),
                      )),
                ],
              ),
              onPressed: () {
                Navigator.pop(context, elementList.product.code);
              },
            ),
          );
        },
      ));
    } else {
      return Expanded(
          child: ListView.builder(
        itemCount: productList!.length,
        itemBuilder: (context, index) {
          final elementList = productList![index];
          return SizedBox(
            height: 40,
            child: OutlinedButton(
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll<Color>(
                      ColorPalette.overlayButton)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(elementList.code,
                            style: Typo.bodyDark),
                      )),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(elementList.description,
                            style: Typo.bodyDark),
                      )),
                ],
              ),
              onPressed: () {
                Navigator.pop(context, elementList.code);
              },
            ),
          );
        },
      ));
    }
  }
}
