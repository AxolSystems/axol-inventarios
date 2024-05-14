import 'package:axol_inventarios/modules/main_/model/modul_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../axol_widget/axol_widget.dart';
import '../cubit/mainview_cubit.dart';
import '../cubit/mainview_state.dart';
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
    return Scaffold(
      body: Row(
        children: [
          ModuleBar(
            select: form.moduleSelect,
            moduleList: form.moduleList,
          ),
          form.body ??
              Expanded(
                  child: Container(
                color: ColorPalette.darkBackground,
              )),
        ],
      ),
    );
  }
}
