import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/appbar_axol.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../sale/sale_note/cubit/salenote_tab/salenote_tab_form.dart';
import '../../../../sale/sale_note/cubit/salenote_tab/salenote_tab_cubit.dart';
import '../../../../sale/view/sale_view.dart';
import '../../../../user/view/views/home_view.dart';
import '../../cubit/routcustomer cubit/routcustomer_cubit.dart';
import '../controller/listview_rc_controller.dart';

class RoutCustomers extends StatelessWidget {
  const RoutCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RoutcustomerCubit()),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.darkBackground,
        appBar: const AppBarAxol(title: 'Clientes de ruta').appBarAxol(),
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
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()));
                  }
                  if (value == 2) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(providers: [
                                  BlocProvider(create: (_) => SaleNoteTabCubit()),
                                  BlocProvider(
                                      create: (_) => SaleNoteTabForm()),
                                ], child: const SaleView())));
                  }
                },
              ),
              /*ViewsBar(
                listData: [
                  ElementsBarModel(
                      icon: const Icon(Icons.house_siding),
                      text: 'Multialmacen',
                      action: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WarehouseMenuView()));
                      }),
                  ElementsBarModel(
                      icon: const Icon(Icons.move_down),
                      text: 'Movimientos',
                      action: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MovementsView()));
                      }),
                  ElementsBarModel(
                      text: 'Productos',
                      icon: const Icon(Icons.grid_view_sharp),
                      action: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductView()));
                      }),
                  ElementsBarModel(
                      text: 'Clientes de ruta',
                      icon: const Icon(Icons.people),
                      action: () {}),
                ],
              ),*/
              const Expanded(child: ListviewRcController()),
            ],
          ),
        ),
      ),
    );
  }
}
