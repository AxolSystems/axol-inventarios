import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../axol_widget/axol_widget.dart';
import '../../../user/repository/user_repo.dart';
import '../../model/main_view_form_model.dart';
import '../../model/modul_model.dart';
import 'mainview_state.dart';

class MainViewCubit extends Cubit<MainViewState> {
  MainViewCubit() : super(InitialMainViewState());

  Future<void> initLoad(BuildContext context, MainViewFormModel form) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());

      form.moduleList = [
        ModuleModel(
          text: 'Modulo de prueba',
          id: '0',
          icon: Icons.home,
          position: 0,
          menu: [],
          permissions: {},
          widget: const TextAW(text: 'Modulo 1'),
          onPressed: () {
            if (form.moduleSelect != 0) {
              form.moduleSelect = 0;
              form.body = const TextAW(text: 'Modulo 1');
              form.title = 'Modulo de prueba';
            } else {
              form.menuVisible = !form.menuVisible;
            }
            context.read<MainViewCubit>().load();
          },
        ),
        ModuleModel(
          text: 'Modulo 2',
          id: '1',
          icon: Icons.home,
          position: 1,
          menu: [],
          permissions: {},
          widget: const TextAW(text: 'Modulo 2'),
          onPressed: () {
            if (form.moduleSelect != 1) {
              form.moduleSelect = 1;
              form.body = const TextAW(text: 'Modulo 2');
              form.title = 'Modulo 2';
            } else {
              form.menuVisible = !form.menuVisible;
            }
            context.read<MainViewCubit>().load();
          },
        )
      ];
      if (form.moduleList.isNotEmpty) {
        form.moduleSelect = 0;
        form.body = form.moduleList.first.widget;
        form.title = form.moduleList.first.text;
      }
      form.user = await LocalUser().getLocalUser();
      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  Future<void> setTheme(UserModel user, int theme, MainViewFormModel form) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      await DatabaseUser().updateTheme(user.id, theme);
      await LocalUser().setTheme(theme);
      form.user = await LocalUser().getLocalUser();
      emit(SetThemeMainViewState(theme: theme));
      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }
}



class MainViewForm extends Cubit<MainViewFormModel> {
  MainViewForm() : super(MainViewFormModel.empty());
}
