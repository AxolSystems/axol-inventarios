import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../axol_widget/axol_widget.dart';
import '../../../axol_widget/table/model/table_cell_model.dart';
import '../../../axol_widget/table/model/table_model.dart';
import '../../../axol_widget/table/view/table_view.dart';
import '../../../object/repository/object_repo.dart';
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
          menu: [],
          permissions: {},
          widget: Expanded(
              child: TableView(
            table: TableModel(header: [
              'Columna 0',
              'Columna 1',
              'Columna 2',
              'Columna 3',
            ], rowList: [
              {
                'Columna 0': CellText(text: 'test0'),
                'Columna 3': CellText(text: 'test1'),
              },
              {
                'Columna 1': CellText(text: 'test2'),
                'Columna 2': CellText(text: 'test3'),
              }
            ]),
          )),
          onPressed: () {
            if (form.moduleSelect != 0) {
              form.moduleSelect = 0;
              form.body = Expanded(
                  child: TableView(
                table: TableModel(header: [
                  'Clumna 0',
                  'Columna 1',
                  'Columna 2',
                  'Columna 3',
                ], rowList: [
                  {
                    'Clumna 0': CellText(text: 'test0'),
                    'Clumna 3': CellText(text: 'test1'),
                  },
                  {
                    'Clumna 1': CellText(text: 'test2'),
                    'Clumna 2': CellText(text: 'test3'),
                  }
                ]),
              ));
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
      final List<ObjectModel> objList = await ObjectRepo.fetchObject(
        BlockModel(
            blockName: '', propertyList: [], tableName: 'table_1', uuid: ''),
        [],
      );
      print(objList.first.id);
      print(objList.first.map);
      print(DateTime.parse(objList.first.dateTime).toLocal());
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

  Future<void> setTheme(
      UserModel user, int theme, MainViewFormModel form) async {
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
