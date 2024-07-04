import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../utilities/widgets/navigation_rail/nav_rail_axol.dart';
import '../../../utilities/widgets/navigation_rail/navigation_rail_axol.dart';
import '../../user/model/user_model.dart';
import '../cubit/salereport_view/salereport_view_cubit.dart';
import '../cubit/salereport_view/salereport_view_state.dart';
import 'srp_doclist_tab.dart';
import 'srp_warehouse_tab.dart';

class SaleReportView extends StatelessWidget {
  const SaleReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SaleReportViewCubit(),
      child: const SaleReportViewBuild(),
    );
  }
}

class SaleReportViewBuild extends StatelessWidget {
  const SaleReportViewBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleReportViewCubit, SaleReportViewState>(
      bloc: context.read<SaleReportViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSaleReportViewState) {
          return saleReportView(context: context, isLoading: false);
        } else if (state is LoadedSaleReportViewState) {
          return saleReportView(
            context: context,
            isLoading: false,
            user: state.user,
          );
        } else {
          return saleReportView(context: context, isLoading: false);
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleReportViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  Widget saleReportView({
    required BuildContext context,
    required bool isLoading,
    UserModel? user,
  }) {
    const String title = 'Reporte de ventas';
    final double widthScreen = MediaQuery.of(context).size.width;
    final Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail = const NavigationRailAxolMain.admin(
          view: NavigationRailAxolView.saleReport);
    } else if (user_.rol == UserModel.rolVendor) {
      navigationRail = const NavigationRailAxolMain.vendor(
          view: NavigationRailAxolView.saleReport);
    } else if (user_.rol == UserModel.rolSup) {
      navigationRail = const NavigationRailAxolMain.sup(
          view: NavigationRailAxolView.saleReport);
    } else {
      navigationRail = const SizedBox();
    }

    return DefaultTabController(
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
                              child: NavRailAxol(navRailMain: navigationRail),
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
                              ? 'Reportes'
                              : 'Reportes de ventas',
                        ),
                      ],
                    ),
                    const Expanded(
                        child: TabBarView(children: [
                      SrpWarehouseTab(),
                      SrpDoclistTab(),
                    ]))
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
