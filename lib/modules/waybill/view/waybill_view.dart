import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/modules/waybill/cubit/waybill_view/waybill_view_cubit.dart';
import 'package:axol_inventarios/modules/waybill/cubit/waybill_view/waybill_view_state.dart';
import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:axol_inventarios/utilities/widgets/navigation_rail/navigation_rail_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../utilities/widgets/navigation_rail/nav_rail_axol.dart';
import '../../inventory_/movements/cubit/movements_view/movements_cubit.dart';
import '../../inventory_/product/cubit/product_tab/product_tab_cubit.dart';
import 'wb_list_tab.dart';
import 'wb_warehouse_tab.dart';

class WaybillView extends StatelessWidget {
  const WaybillView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaybillViewCubit(),
      child: const WaybillViewBuild(),
    );
  }
}

class WaybillViewBuild extends StatelessWidget {
  const WaybillViewBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaybillViewCubit, WaybillViewState>(
      bloc: context.read<WaybillViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingWaybillViewState) {
          return waybillView(context: context, isLoading: false);
        } else if (state is LoadedWaybillViewState) {
          return waybillView(
            context: context,
            isLoading: false,
            user: state.user,
          );
        } else {
          return waybillView(context: context, isLoading: false);
        }
      },
      listener: (context, state) {
        if (state is ErrorWaybillViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  Widget waybillView({
    required BuildContext context,
    required bool isLoading,
    UserModel? user,
  }) {
    const String title = 'Listas para carta porte';
    final double widthScreen = MediaQuery.of(context).size.width;
    final Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail = const NavigationRailAxolMain.admin(
          view: NavigationRailAxolView.waybill);
    } else if (user_.rol == UserModel.rolVendor) {
      navigationRail = const NavigationRailAxolMain.vendor(
          view: NavigationRailAxolView.waybill);
    } else if (user_.rol == UserModel.rolSup) {
      navigationRail = const NavigationRailAxolMain.sup(
          view: NavigationRailAxolView.waybill);
    } else {
      navigationRail = const SizedBox();
    }

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
                isLoading: isLoading,
                leading: widthScreen < 600
                    ? LeadingMenu(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Row(
                              children: [
                                Material(
                                  child:
                                      NavRailAxol(navRailMain: navigationRail),
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
                        child: NavRailAxol(
                          navRailMain: navigationRail,
                        )),
                    const VerticalDivider(
                        thickness: 1, width: 1, color: ColorPalette.darkItems20),
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
