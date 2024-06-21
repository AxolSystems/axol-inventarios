import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../main_/cubit/main_view/mainview_cubit.dart';
import '../../main_/cubit/main_view/mainview_state.dart';
import '../cubit/set_module/set_module_cubit.dart';
import '../cubit/set_module/set_module_state.dart';
import '../model/set_module_form_model.dart';

class SetModuleWidget extends AxolWidget {
  const SetModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetModuleCubit()),
        BlocProvider(create: (_) => SetModuleForm()),
      ],
      child: const SetModuleWidgetBuild(),
    );
  }
}

class SetModuleWidgetBuild extends AxolWidget {
  const SetModuleWidgetBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetModuleCubit, SetModuleState>(
      builder: (context, state) {
        if (state is LoadingSetModuleState) {}
      },
      listener: (context, state) {},
    );
  }

  Widget setModuleWidget(
      BuildContext context, SetModuleFormModel form, bool isLoading) {
    return isLoading
        ? Expanded(
            child: Container(
            color: ColorTheme.background(form.theme),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [LinearProgressIndicatorAxol()],
            ),
          ))
        : BlocListener<MainViewCubit, MainViewState>(
            listener: (context, state) {
              if (state is SetThemeMainViewState) {
                form.theme = state.theme;
                context.read<SetModuleCubit>().load();
              }
            },
            child: Expanded(child: LayoutBuilder(
              builder: (context, constraints) {
                final double paddingBox;
                final double heightBox;
                bool isBoxNarrow = false;
                if (constraints.maxWidth > 1450) {
                  paddingBox = 130;
                  heightBox = 108;
                } else if (constraints.maxWidth > 1190) {
                  paddingBox = 110;
                  heightBox = 108;
                } else if (constraints.maxWidth > 940) {
                  paddingBox = 50;
                  heightBox = 108;
                } else {
                  paddingBox = 16;
                  heightBox = 150;
                  isBoxNarrow = true;
                }
                
                return Container(
                  color: ColorTheme.background(form.theme),
                  child: RawScrollbar,
                );
              },
            )),
          );
  }
}
