import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../utilities/navigation_utilities.dart';
import '../../../utilities/theme/theme.dart';
import '../../inventory_/inventory/view/inventory_view.dart';
import '../../user/view/views/home_view.dart';
import '../../waybill/view/waybill_view.dart';
import '../customer/view/customer_tab.dart';
import '../sale_note/cubit/salenote_tab/salenote_tab_form.dart';
import '../sale_note/cubit/salenote_tab/salenote_tab_cubit.dart';
import '../sale_note/view/salenote_tab.dart';

class SaleView extends StatelessWidget {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SaleNoteTabCubit()),
        BlocProvider(create: (_) => SaleNoteTabForm()),
      ],
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: ColorPalette.darkBackground,
            appBar: AppBarAxol.appBar(title: 'Ventas'),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavigationRail(
                    labelType: NavigationRailLabelType.all,
                    destinations: NavigationUtilities.admin,
                    selectedIndex: 2,
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
                                builder: (context) => const InventoryView()));
                      }
                      if (value == 3) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WaybillView()));
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
                            text: 'Notas de venta',
                          ),
                          Tab(
                            text: 'Remisiones',
                          ),
                          Tab(
                            text: 'Clientes',
                          ),
                          Tab(
                            text: 'Vendedores',
                          ),
                        ],
                      ),
                      Expanded(
                          child: TabBarView(children: [
                        SaleNoteTab(
                          saleType: 0,
                        ),
                        SaleNoteTab(
                          saleType: 1,
                        ),
                        CustomerTab(),
                        ProviderVendorTab(),
                        //Text('Vendedores', style: Typo.bodyLight),
                      ])),
                    ],
                  )),
                ],
              ),
            ),
          )),
    );
  }
}
