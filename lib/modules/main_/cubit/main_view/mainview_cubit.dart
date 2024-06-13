import 'package:axol_inventarios/modules/axol_widget/widget_index.dart';
import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/modules/widget_link/model/widget_view_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../axol_widget/axol_widget.dart';
import '../../../object/repository/object_repo.dart';
import '../../../user/repository/user_repo.dart';
import '../../model/main_view_form_model.dart';
import '../../model/modul_model.dart';
import '../../repository/module_repo.dart';
import 'mainview_state.dart';

class MainViewCubit extends Cubit<MainViewState> {
  MainViewCubit() : super(InitialMainViewState());

  Future<void> initLoad(BuildContext context, MainViewFormModel form) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final List<ModuleModel> moduleList;
      final ModuleModel module;
      final AxolWidget axolWidget;
      final List<ObjectModel> objects;
      final WidgetLinkModel link;
      final WidgetViewModel view;

      /*form.moduleList = [
        ModuleModel(
          name: 'Modulo de prueba',
          id: '0',
          icon: Icons.home,
          widgetLinks: [],
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
          name: 'Modulo 2',
          id: '1',
          icon: Icons.home,
          widgetLinks: [],
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
      ];*/

      moduleList = await ModuleRepo.fetchModuleList();

      if (moduleList.isNotEmpty) {
        module = moduleList[0];
        print(form.viewSelect);
        print(form.linkSelect);
        if (module.widgetLinks.isNotEmpty) {
          print('111');
          link = module.widgetLinks.first;
          if (link.views.isNotEmpty) {
            view = link.views.first;
          } else {
            view = WidgetViewModel.empty();
          }

          objects = await ObjectRepo.fetchObject(link.block, view.filterList);
          /*axolWidget = WidgetIndex.widget(
              link.widget,
              WidgetIndex.data(link.widget, objects, link.block),
              form.user.theme);*/
          form.title = moduleList.first.name;
        } else {
          print('222');
          //axolWidget = const EmptyWidget();
          link = WidgetLinkModel.empty();
          objects = [];
        }
        form.moduleList = moduleList;
        form.moduleSelect = 0;
        form.widgetLink = link;
        form.objects = objects;

        //form.body = axolWidget;
      }
      form.user = await LocalUser().getLocalUser();
      /*final List<ObjectModel> objList = await ObjectRepo.fetchObject(
        BlockModel(
            blockName: '', propertyList: [], tableName: 'table_1', uuid: ''),
        [],
      );*/

      //print(objList.first.id);
      //print(objList.first.map);
      //print(DateTime.parse(objList.first.createAt).toLocal());
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

  Future<void> setWidgetLink(MainViewFormModel form, int index, int subIndex,
      WidgetLinkModel link, WidgetViewModel view) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final List<ObjectModel> objects;

      objects = await ObjectRepo.fetchObject(link.block, view.filterList);
      if (form.linkSelect != index) {
        form.linkSelect = index;
        form.widgetLink = link;
        form.objects = objects;
        /*form.body = WidgetIndex.widget(
            link.widget,
            WidgetIndex.data(link.widget, objects, link.block),
            form.user.theme);*/
        form.title = view.name;
      }
      if (form.viewSelect != subIndex) {
        form.viewSelect = subIndex;
        form.widgetLink = link;
        form.objects = objects;
        /*form.body = WidgetIndex.widget(
            link.widget,
            WidgetIndex.data(link.widget, objects, link.block),
            form.user.theme);*/
        form.title = view.name;
      }
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
