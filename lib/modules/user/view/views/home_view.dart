import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/navigation_rail_axol.dart';
import '../../cubit/home_view/home_view_cubit.dart';
import '../../cubit/home_view/home_view_state.dart';
import '../../model/user_mdoel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewCubit(),
      child: const HomeViewBuild(),
    );
  }
}

class HomeViewBuild extends StatelessWidget {
  const HomeViewBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return BlocConsumer<HomeViewCubit, HomeViewState>(
      bloc: context.read<HomeViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingHomeViewState) {
          return homeView(
            context: context,
            isLoading: true,
            widthScreen: widthScreen,
          );
        } else if (state is LoadedHomeViewState) {
          return homeView(
            context: context,
            isLoading: false,
            user: state.user,
            widthScreen: widthScreen,
          );
        } else {
          return homeView(
            context: context,
            isLoading: false,
            widthScreen: widthScreen,
          );
        }
      },
      listener: (context, state) {
        if (state is ErrorHomeViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  Widget homeView({
    required BuildContext context,
    required bool isLoading,
    required double widthScreen,
    UserModel? user,
  }) {
    final double widthScreen = MediaQuery.of(context).size.width;
    const String title = 'Inicio';
    Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail =
          const NavigationRailAxolMain.admin(view: NavigationRailAxolView.home);
    } else if (user_.rol == UserModel.rolVendor) {
      navigationRail = const NavigationRailAxolMain.vendor(
          view: NavigationRailAxolView.home);
    } else {
      navigationRail = const SizedBox();
    }
    return Scaffold(
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
                        navigationRail,
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
              child: navigationRail,
            ),
            const VerticalDivider(
                thickness: 1, width: 1, color: ColorPalette.darkItems),
            const Expanded(child: SizedBox()),
            SizedBox(
                width: widthScreen > 790
                    ? 700
                    : widthScreen >= 600
                        ? widthScreen - 90
                        : widthScreen - 16,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: MarkdownBody(
                            selectable: true,
                            data: '''
# Versión: 1.0.4

- Agregado buscador para formulario de nuevo elemento en listas de carta porte.
- Se ajustaron los tamaños de las celdas en el formulario de nuevo movimiento al 
inventario, y se agregó peso total de los movimientos agregados.
- Agregado soporte en markdown para notas de versión. 
                        ''',
                            styleSheet: MarkdownStyleSheet(
                              h1: Typo.titleLight,
                              p: Typo.bodyLight,
                              listBullet: const TextStyle(
                                  fontSize: 20, color: ColorPalette.lightText),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                )),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
