import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

import '../modules/inventory_/inventory/view/inventory_view.dart';
import '../modules/sale/view/sale_view.dart';
import '../modules/user/view/views/home_view.dart';
import '../modules/waybill/view/waybill_view.dart';
import 'widgets/button.dart';

class NavigationUtilities {
  static const List<NavigationRailDestination> admin = [
    NavigationRailDestination(
        icon: Icon(
          Icons.home,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Inicio',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.inventory,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Inventario',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.note,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Notas',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.list_alt,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Carta porte',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
  ];

  static const List<NavigationRailDestination> vendor = [
    NavigationRailDestination(
        icon: Icon(
          Icons.home,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Inicio',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.list_alt,
          color: ColorPalette.lightBackground,
        ),
        label: Text(
          'Carta porte',
          style: Typo.labelLight,
        ),
        indicatorColor: ColorPalette.primary),
  ];

  static Function(int value) destinationAdmin(
      int indexSelect, BuildContext context) {
    int indexCount;
    List<int> indexList = [];
    List<Widget> viewList = [
      const HomeView(),
      const InventoryView(),
      const SaleView(),
      const WaybillView(),
    ];

    indexCount = viewList.length;
    for (int i = 0; i < indexCount; i++) {
      if (indexSelect == i) {
        indexList.add(-1);
      } else {
        indexList.add(i);
      }
    }

    return (value) {
      if (value == indexList[0]) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => viewList[0]));
      }
      if (value == indexList[1]) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => viewList[1]));
      }
      if (value == indexList[2]) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => viewList[2]));
      }
      if (value == indexList[3]) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => viewList[3]));
      }
    };
  }

  static Widget emptyNavRailReturn() => const SizedBox(
        width: 72,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ButtonReturnView(),
        ),
      );
}
