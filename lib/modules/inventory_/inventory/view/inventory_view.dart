import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/navigation_rail_axol.dart';
import '../../../sale/sale_note/view/sale_view.dart';
import '../../../user/model/user_mdoel.dart';
import '../../../user/view/views/home_view.dart';
import '../../../waybill/view/waybill_view.dart';
import '../../movements/cubit/movements_view/movements_cubit.dart';
import '../../movements/view/movement_tab.dart';
import '../../product/cubit/product_tab/product_tab_cubit.dart';
import '../../product/view/product_tab.dart';
import '../cubit/inventory_view/inventory_view_cubit.dart';
import '../cubit/inventory_view/inventory_view_state.dart';
import 'warehouse_tab.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryViewCubit(),
      child: const InventoryViewBuild(),
    );
  }
}

class InventoryViewBuild extends StatelessWidget {
  const InventoryViewBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryViewCubit, InventoryViewState>(
      bloc: context.read<InventoryViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingInventoryViewState) {
          return inventoryView(context: context, isLoading: true);
        } else if (state is LoadedInventoryViewState) {
          return inventoryView(
            context: context,
            isLoading: false,
            user: state.user,
          );
        } else {
          return inventoryView(context: context, isLoading: false);
        }
      },
      listener: (context, state) {
        if (state is ErrorInventoryViewState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget inventoryView({
    required BuildContext context,
    required bool isLoading,
    UserModel? user,
  }) {
    const String title = 'Inventario';
    Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail =
          const NavigationRailAxolMain.admin(view: NavigationRailAxolView.inventory);
    } else {
      navigationRail = const SizedBox();
    }
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MovementsCuibit()),
          BlocProvider(create: (_) => ProductTabCubit()),
        ],
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: ColorPalette.darkBackground,
              appBar: AppBarAxol.appBar(title: title),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    navigationRail,
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
