import 'package:flutter/material.dart';

import '../navigation_utilities.dart';
import '../theme/theme.dart';

////
//// ---- NavigagationRailAxol ----
////
class NavigationRailAxol extends StatelessWidget {
  final List<NavigationRailDestination> destinations;
  final int? selectedIndex;
  final Function(int)? onDestinationSelected;
  const NavigationRailAxol({
    super.key,
    required this.destinations,
    this.onDestinationSelected,
    this.selectedIndex,
  });

  NavigationRailAxol.empty({
    super.key,
    this.onDestinationSelected,
    this.selectedIndex,
  }) : destinations = [];

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      destinations: destinations,
      selectedIndex: selectedIndex,
      backgroundColor: ColorPalette.darkBackground,
      indicatorColor: ColorPalette.primary,
      useIndicator: true,
      onDestinationSelected: onDestinationSelected,
    );
  }
}

////
//// ---- NavigationRailAxolMain ----
////
enum NavigationRailAxolView { home, inventory, note, waybill }

enum NavigationRailAxolRol { admin, vendor }

class NavigationRailAxolMain extends StatelessWidget {
  final NavigationRailAxolRol rol;
  final NavigationRailAxolView view;
  const NavigationRailAxolMain(
      {super.key, required this.rol, required this.view});

  const NavigationRailAxolMain.admin({super.key, required this.view})
      : rol = NavigationRailAxolRol.admin;

  const NavigationRailAxolMain.vendor({super.key, required this.view})
      : rol = NavigationRailAxolRol.vendor;

  @override
  Widget build(BuildContext context) {
    if (rol == NavigationRailAxolRol.admin) {
      if (view == NavigationRailAxolView.home) {
        return NavigationRailAxol(
          destinations: NavigationUtilities.admin,
          selectedIndex: 0,
          onDestinationSelected:
              NavigationUtilities.destinationAdmin(0, context),
        );
      } else if (view == NavigationRailAxolView.inventory) {
        return NavigationRailAxol(
          destinations: NavigationUtilities.admin,
          selectedIndex: 1,
          onDestinationSelected:
              NavigationUtilities.destinationAdmin(1, context),
        );
      } else if (view == NavigationRailAxolView.note) {
        return NavigationRailAxol(
          destinations: NavigationUtilities.admin,
          selectedIndex: 2,
          onDestinationSelected:
              NavigationUtilities.destinationAdmin(2, context),
        );
      } else if (view == NavigationRailAxolView.waybill) {
        return NavigationRailAxol(
          destinations: NavigationUtilities.admin,
          selectedIndex: 3,
          onDestinationSelected:
              NavigationUtilities.destinationAdmin(3, context),
        );
      } else {
        return NavigationRailAxol.empty();
      }
    } else {
      return NavigationRailAxol.empty();
    }
  }
}
