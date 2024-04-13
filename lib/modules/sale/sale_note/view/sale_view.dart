import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/navigation_rail/navigation_rail_axol.dart';
import '../../../user/model/user_mdoel.dart';
import '../../customer/view/customer_tab.dart';
import '../cubit/sale_view/sale_view_cubit.dart';
import '../cubit/sale_view/sale_view_state.dart';
import '../cubit/salenote_tab/salenote_tab_form.dart';
import '../cubit/salenote_tab/salenote_tab_cubit.dart';
import 'salenote_tab.dart';

class SaleView extends StatelessWidget {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SaleViewCubit(),
      child: const SaleViewBuild(),
    );
  }
}

class SaleViewBuild extends StatelessWidget {
  const SaleViewBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleViewCubit, SaleViewState>(
      bloc: context.read<SaleViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSaleViewState) {
          return saleView(context: context, isLoading: true);
        } else if (state is LoadedSaleViewState) {
          return saleView(context: context, isLoading: false, user: state.user);
        } else {
          return saleView(context: context, isLoading: false);
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  Widget saleView({
    required BuildContext context,
    required bool isLoading,
    UserModel? user,
  }) {
    Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail =
          const NavigationRailAxolMain.admin(view: NavigationRailAxolView.note);
    } else {
      navigationRail = const SizedBox();
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SaleNoteTabCubit()),
        BlocProvider(create: (_) => SaleNoteTabForm()),
      ],
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: ColorPalette.darkBackground,
            appBar: AppBarAxol.appBar(
              title: 'Ventas',
              isLoading: isLoading,
            ),
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
