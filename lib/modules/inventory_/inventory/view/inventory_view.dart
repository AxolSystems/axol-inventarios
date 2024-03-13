import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/appbar_axol.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../sale/view/sale_view.dart';
import '../../../user/view/views/home_view.dart';
import '../../movements/cubit/movements_view/movements_cubit.dart';
import '../../movements/view/movement_tab.dart';
import '../../product/cubit/product_tab/product_tab_cubit.dart';
import '../../product/view/product_tab.dart';
import '../cubit/warehouses_load/warehouses_load_cubit.dart';
import 'warehouse_tab.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Menú de almacenes';
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MovementsCuibit()),
          BlocProvider(create: (_) => WarehousesLoadCubit()),
          BlocProvider(create: (_) => ProductTabCubit()),
        ],
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: ColorPalette.darkBackground,
              appBar: const AppBarAxol(title: title).appBarAxol(),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationRail(
                      destinations: NavigationUtilities.navRail,
                      selectedIndex: 1,
                      backgroundColor: ColorPalette.darkBackground,
                      indicatorColor: ColorPalette.primary,
                      useIndicator: true,
                      onDestinationSelected: (value) {
                        if (value == 0) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        }
                        if (value == 2) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SaleView()));
                        }
                      },
                    ),
                    const VerticalDivider(
                        thickness: 1, width: 1, color: ColorPalette.darkItems),
                    const Expanded(
                        child: Column(
                      children: [
                        TabBar(
                          indicatorColor: ColorPalette.primary,
                          tabs: [
                            Tab(
                              text: 'Multialmacen',
                            ),
                            Tab(
                              text: 'Movimientos',
                            ),
                            Tab(
                              text: 'Productos',
                            ),
                          ],
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          WarehouseTab(),
                          MovementTab(),
                          ProductTab(),
                        ]))
                      ],
                    )),
                  ],
                ),
              ),
            )));
  }
}
