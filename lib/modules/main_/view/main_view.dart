import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/main_view/mainview_cubit.dart';
import '../cubit/main_view/mainview_state.dart';
import '../model/main_view_form_model.dart';
import 'module_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainViewCubit()),
        BlocProvider(create: (_) => MainViewForm()),
      ],
      child: MainViewBuild(),
    );
  }
}

class MainViewBuild extends StatelessWidget {
  const MainViewBuild({super.key});
  @override
  Widget build(BuildContext context) {
    MainViewFormModel form = context.read<MainViewForm>().state;
    return BlocConsumer<MainViewCubit, MainViewState>(
      bloc: context.read<MainViewCubit>()..initLoad(context, form),
      builder: (context, state) {
        if (state is LoadingMainViewState) {
          return mainView(context, true, form);
        } else if (state is LoadedMainViewState) {
          return mainView(context, false, form);
        } else {
          return mainView(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorMainViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  Widget mainView(
      BuildContext context, bool isLoading, MainViewFormModel form) {
    return Material(
        child: Column(
      children: [
        Container(
          height: 60,
          decoration: const BoxDecoration(
              color: ColorPalette.darkBackground,
              border:
                  Border(bottom: BorderSide(color: ColorPalette.darkItems20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 60,
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.circle,
                  child: IconButton(
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      form.moduleBarVisible = !form.moduleBarVisible;
                      context.read<MainViewCubit>().load();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: ColorPalette.lightItems10,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Text(
                form.title,
                style: Typo.titleLightH2,
              ),
              const Expanded(child: SizedBox()),
              Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Row(
          children: [
            Visibility(
              visible: form.moduleBarVisible,
              child: ModuleBar(
                select: form.moduleSelect,
                moduleList: form.moduleList,
                menuVisible: form.menuVisible,
                onPressedSetting: () {
                  if (form.moduleSelect == -1) {
                    form.menuVisible = !form.menuVisible;
                  }
                  form.moduleSelect = -1;
                  form.title = 'Configuración';
                  context.read<MainViewCubit>().load();
                },
              ),
            ),
            form.body ??
                Expanded(
                    child: Container(
                  color: ColorPalette.darkBackground,
                )),
          ],
        ))
      ],
    ));
  }
}
