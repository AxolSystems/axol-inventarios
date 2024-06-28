import 'dart:math';

import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/widgetlink_drawer_cubit.dart';
import '../cubit/widgetlink_drawer_state.dart';
import '../model/widgetlink_drawer_form_model.dart';
import '../model/widgetlink_model.dart';

class WidgetLinkDrawer extends StatelessWidget {
  final int theme;
  final List<WidgetLinkModel> moduleLinks;
  const WidgetLinkDrawer(
      {super.key, required this.theme, required this.moduleLinks});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WLinkDrawerCubit()),
        BlocProvider(create: (_) => WLinkDrawerForm()),
      ],
      child: WidgetLinkDrawerBuild(theme: theme, moduleLinks: moduleLinks),
    );
  }
}

class WidgetLinkDrawerBuild extends StatelessWidget {
  final int theme;
  final List<WidgetLinkModel> moduleLinks;
  const WidgetLinkDrawerBuild(
      {super.key, required this.theme, required this.moduleLinks});

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
            width: 0.45,
            theme: theme,
            header: const LinearProgressIndicatorAxol(),
          )
        : DrawerBox(
            width: 0.45,
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
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: form.links.length,
                itemBuilder: (context, index) {
                  final WidgetLinkModel link = form.links[index];
                  final bool exist =
                      moduleLinks.indexWhere((x) => x.id == link.id) > -1;
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      shape: const ContinuousRectangleBorder(),
                    ),
                    onPressed: exist ? null : () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorTheme.item30(theme)),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(link.id, style: Typo.body(theme)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Text(link.block.blockName,
                                style: Typo.body(theme)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Text(link.widget.toString(),
                                style: Typo.body(theme)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Text(link.views.length.toString(),
                                style: Typo.body(theme)),
                          ),
                          Visibility(
                            visible: exist,
                            replacement: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.chevron_right_sharp,
                                color: ColorTheme.item20(theme),
                                size: 24,
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.check_circle_outline_outlined,
                                color: ColorPalette.correct,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
