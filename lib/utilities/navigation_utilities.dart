import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';

import 'widgets/button.dart';

class NavigationUtilities {
  static const List<NavigationRailDestination> navRail = [
    NavigationRailDestination(
        icon: Icon(
          Icons.home,
          color: ColorPalette.lightBackground,
        ),
        label: Text('Inicio'),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.inventory,
          color: ColorPalette.lightBackground,
        ),
        label: Text('Inventario'),
        indicatorColor: ColorPalette.primary),
    NavigationRailDestination(
        icon: Icon(
          Icons.note,
          color: ColorPalette.lightBackground,
        ),
        label: Text('Notas'),
        indicatorColor: ColorPalette.primary),
  ];
  //static const List<NavigationRailDestination> navRailReturn = [];

  static Widget emptyNavRailReturn() => const SizedBox(
        width: 72,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ButtonReturnView(),
        ),
      );
}
