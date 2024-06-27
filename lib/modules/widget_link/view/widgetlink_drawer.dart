import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/widgetlink_drawer_cubit.dart';
import '../cubit/widgetlink_drawer_state.dart';
import '../model/widgetlink_drawer_form_model.dart';

class WidgetLinkDrawer extends StatelessWidget {
  final int theme;
  const WidgetLinkDrawer({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WLinkDrawerCubit()),
        BlocProvider(create: (_) => WLinkDrawerForm()),
      ],
      child: WidgetLinkDrawerBuild(theme: theme),
    );
  }
}

class WidgetLinkDrawerBuild extends StatelessWidget {
  final int theme;
  const WidgetLinkDrawerBuild({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    WLinkDrawerFormModel form = context.read<WLinkDrawerForm>().state;
    return BlocConsumer<WLinkDrawerCubit, WLinkDrawerState>(
      bloc: context.read<WLinkDrawerCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingWLinkDrawerState) {
          return widgetBuild(context, true, form);
        } else if (state is LoadingWLinkDrawerState) {
          return widgetBuild(context, false, form);
        } else {
          return widgetBuild(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorWLinkDrawerState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget widgetBuild(
      BuildContext context, bool isLoading, WLinkDrawerFormModel form) {
    return isLoading
        ? DrawerBox(
            width: 0.4,
            theme: theme,
            header: const LinearProgressIndicatorAxol(),
          )
        : DrawerBox(
            width: 0.4,
            theme: theme,
            header: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorTheme.item30(theme)),
                      ),
                    ),
                    child: Text(
                      'Búsqueda de links',
                      style: Typo.titleH2(theme),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
