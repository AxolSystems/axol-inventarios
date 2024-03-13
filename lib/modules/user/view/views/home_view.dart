import 'package:flutter/material.dart';

import '../../../../utilities/widgets/appbar_axol.dart';
import '../../../../utilities/navigation_utilities.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../inventory_/inventory/view/inventory_view.dart';
import '../../../sale/view/sale_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Inicio';

    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: const AppBarAxol(title: title).appBarAxol(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            NavigationRail(
              destinations: NavigationUtilities.navRail,
              selectedIndex: 0,
              backgroundColor: ColorPalette.darkBackground,
              indicatorColor: ColorPalette.primary,
              useIndicator: true,
              onDestinationSelected: (value) {
                if (value == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InventoryView()));
                }
                if (value == 2) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SaleView()));
                }
              },
            ),
            const VerticalDivider(
                thickness: 1, width: 1, color: ColorPalette.darkItems),
          ],
        ),
      ),
    );
  }
}
