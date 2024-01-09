import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/appbar/appbar_global.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../global_widgets/toolbar.dart';
import '../../../../../models/elemnets_bar_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/button.dart';
import '../../../../sale/view/sale_view.dart';
import '../../../../user/view/views/home_view.dart';
import '../../../product/cubit/products/products_cubit.dart';
import '../../cubit/inventory_load/inventory_load_cubit.dart';
import '../../cubit/textfield_finder_invrow_cubit.dart';
import '../../model/warehouse_model.dart';
import '../controllers/listview_warehouse_controller.dart';

import '../widgets/textfield_finder_inventoryrow.dart';
import 'inventory_movement_view.dart';

class WarehouseView extends StatelessWidget {
  final WarehouseModel warehouse;
  //final List<UserModel> users;
  const WarehouseView({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    const String title = 'View de almacén';
    final double screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryLoadCubit()),
        BlocProvider(create: (_) => TextfieldFinderInvrowCubit()),
        BlocProvider(create: (_) => ProductsCubit()),
      ],
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: ColorPalette.darkBackground,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarGlobal(
              title: title,
              iconButton: null,
              iconActions: [],
            ),
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigationRail(
                  leading: const ButtonReturnView(),
                  destinations: NavigationUtilities.navRail,
                  selectedIndex: 1,
                  backgroundColor: ColorPalette.darkBackground,
                  indicatorColor: ColorPalette.primary,
                  useIndicator: true,
                  onDestinationSelected: (value) {
                    if (value == 0) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeView()));
                    }
                    if (value == 2) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SaleView()));
                    }
                  },
                ),
                const VerticalDivider(
                    thickness: 1, width: 1, color: ColorPalette.darkItems),
                Expanded(
                  child: TabBarView(children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              const Text(
                                'Almacén: ',
                                style: Typo.bodyText5,
                              ),
                              Text(
                                warehouse.name,
                                style: Typo.bodyText5,
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width:
                                    screenWidth > 650 ? screenWidth - 460 : 190,
                                child: TextfieldFinderInventroyrow(
                                    inventoryName: warehouse.name),
                              )
                            ],
                          ),
                        ),
                        ListviewWarehouseController(
                          warehouseName: warehouse.name,
                        ),
                      ],
                    ),
                    const Center(child: Text('Tab2')),
                    const Center(child: Text('Tab3')),
                  ]),
                ),
                Toolbar(
                  listData: [
                    ElementsBarModel(
                      text: null,
                      icon: const Icon(Icons.add),
                      action: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryMovementView(
                                      warehouse: warehouse,
                                    )));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
