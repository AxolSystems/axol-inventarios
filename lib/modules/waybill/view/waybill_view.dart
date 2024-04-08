import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../utilities/navigation_utilities.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../inventory_/inventory/view/inventory_view.dart';
import '../../inventory_/movements/cubit/movements_view/movements_cubit.dart';
import '../../inventory_/product/cubit/product_tab/product_tab_cubit.dart';
import '../../sale/view/sale_view.dart';
import '../../user/view/views/home_view.dart';
import 'wb_list_tab.dart';
import 'wb_warehouse_tab.dart';

class WaybillView extends StatelessWidget {
  const WaybillView({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Listas para carta porte';
    final double widthScreen = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MovementsCuibit()),
          BlocProvider(create: (_) => ProductTabCubit()),
        ],
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: ColorPalette.darkBackground,
              appBar: AppBarAxol.appBar(
                title: title,
                leading: widthScreen < 600
                    ? LeadingMenu(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Row(
                              children: [
                                NavigationRail(
                                    labelType: NavigationRailLabelType.all,
                                    destinations: NavigationUtilities.admin,
                                    selectedIndex: 3,
                                    backgroundColor:
                                        ColorPalette.darkBackground,
                                    indicatorColor: ColorPalette.primary,
                                    useIndicator: true,
                                    onDestinationSelected: (value) {
                                      if (value == 0) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeView()));
                                      }
                                      if (value == 1) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const InventoryView()));
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
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          );
                        },
                      )
                    : null,
              ),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: widthScreen >= 600,
                      child: NavigationRail(
                        destinations: NavigationUtilities.admin,
                        selectedIndex: 3,
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
                          if (value == 1) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InventoryView()));
                          }
                          if (value == 2) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SaleView()));
                          }
                        },
                      ),
                    ),
                    const VerticalDivider(
                        thickness: 1, width: 1, color: ColorPalette.darkItems),
                    Expanded(
                        child: Column(
                      children: [
                        TabBar(
                          indicatorColor: ColorPalette.primary,
                          tabs: [
                            const Tab(
                              text: 'Almacén',
                            ),
                            Tab(
                              text: widthScreen < 600
                                  ? 'Listas'
                                  : 'Listas para carta porte',
                            ),
                          ],
                        ),
                        const Expanded(
                            child: TabBarView(children: [
                          WbWarehouseTab(),
                          WbListTab(),
                        ]))
                      ],
                    )),
                  ],
                ),
              ),
            )));
  }
}
