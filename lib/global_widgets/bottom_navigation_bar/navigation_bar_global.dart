import 'package:flutter/material.dart';

import '../../utilities/theme/theme.dart';

class NavigationBarGlobal extends StatelessWidget {
  final int currentIndex;
  const NavigationBarGlobal({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ventas',
          backgroundColor: ColorPalette.primary,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventaio',
          backgroundColor: ColorPalette.primary,
        )
      ],
      backgroundColor: ColorPalette.lightBackground,
      currentIndex: currentIndex,
      onTap: (value) {
        switch (value) {
          case 0:
            /*if (currentIndex != value) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalesView()),
              );
            }*/
            break;
          case 1:
            /*if (currentIndex != value) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InventoryView()),
              );
            }*/
            break;
          default:
        }
      },
    );
  }
}
