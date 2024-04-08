import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/navigation_rail_axol.dart';
import '../../cubit/home_view_cubit/home_view_cubit.dart';
import '../../cubit/home_view_cubit/home_view_state.dart';
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
    return BlocConsumer<HomeViewCubit, HomeViewState>(
      bloc: context.read<HomeViewCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingHomeViewState) {
          return homeView(context: context, isLoading: true);
        } else if (state is LoadedHomeViewState) {
          return homeView(context: context, isLoading: false, user: state.user);
        } else {
          return homeView(context: context, isLoading: false);
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
    UserModel? user,
  }) {
    const String title = 'Inicio';
    Widget navigationRail;
    UserModel user_ = user ?? UserModel.empty();

    if (user_.rol == UserModel.rolAdmin) {
      navigationRail =
          const NavigationRailAxolMain.admin(view: NavigationRailAxolView.home);
    } else {
      navigationRail = const SizedBox();
    }
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol.appBar(
        title: title,
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
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Version: 1.0.2', style: Typo.titleLight),
            )
          ],
        ),
      ),
    );
  }
}
