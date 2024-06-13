import 'package:axol_inventarios/modules/axol_widget/widget_index.dart';
import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:axol_inventarios/modules/widget_link/model/widget_view_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../axol_widget/axol_widget.dart';
import '../../../block/view/setblock_widget.dart';
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

      moduleList = await ModuleRepo.fetchModuleList();

      if (moduleList.isNotEmpty) {
        module = moduleList[0];
        if (module.widgetLinks.isNotEmpty) {
          link = module.widgetLinks.first;
          if (link.views.isNotEmpty) {
            view = link.views.first;
          } else {
            view = WidgetViewModel.empty();
          }

          objects = await ObjectRepo.fetchObject(link.block, view.filterList);
          axolWidget = WidgetIndex.widget(
              link.widget,
              WidgetIndex.data(link.widget, objects, link.block),
              form.user.theme);
          form.title = moduleList.first.name;
        } else {
          axolWidget = const EmptyWidget();
          link = WidgetLinkModel.empty();
          objects = [];
        }
        form.moduleList = moduleList;
        form.moduleSelect = 0;
        //form.widgetLink = link;
        //form.objects = objects;

        form.body = axolWidget;
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

  Future<void> setWidgetLink(
      MainViewFormModel form, int indexLink, int indexView) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final List<ObjectModel> objects;
      final ModuleModel module;
      final WidgetLinkModel link;
      final WidgetViewModel view;

      module = form.moduleList[form.moduleSelect];
      if (module.widgetLinks.isNotEmpty) {
        link = module.widgetLinks[indexLink];
        if (link.views.isNotEmpty) {
          view = link.views[indexView];
        } else {
          view = WidgetViewModel.empty();
        }
        objects = await ObjectRepo.fetchObject(link.block, view.filterList);
        if (form.linkSelect != indexLink || form.viewSelect != indexView) {
          form.linkSelect = indexLink;
          form.viewSelect = indexView;
          form.body = WidgetIndex.widget(
              link.widget,
              WidgetIndex.data(link.widget, objects, link.block),
              form.user.theme);
        }
        form.title = module.name;
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  Future<void> setModule(MainViewFormModel form, int indexModule) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final List<ObjectModel> objects;
      final ModuleModel module;
      final WidgetLinkModel link;
      final WidgetViewModel view;

      if (indexModule != form.moduleSelect) {
        form.moduleSelect = indexModule;
        module = form.moduleList[indexModule];
        if (module.widgetLinks.isNotEmpty) {
          link = module.widgetLinks[indexLink];
          if (link.views.isNotEmpty) {
            view = link.views[indexView];
          } else {
            view = WidgetViewModel.empty();
          }
          objects = await ObjectRepo.fetchObject(link.block, view.filterList);
          if (form.linkSelect != indexLink || form.viewSelect != indexView) {
            form.linkSelect = indexLink;
            form.viewSelect = indexView;
            form.body = WidgetIndex.widget(
                link.widget,
                WidgetIndex.data(link.widget, objects, link.block),
                form.user.theme);
          }
          form.title = module.name;
        }
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  Future<void> setSetting(MainViewFormModel form, int linkSelect) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());

      form.body = SetBlockWidget(theme: form.user.theme);

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
      UserModel userx;
      await DatabaseUser().updateTheme(user.id, theme);
      await LocalUser().setTheme(theme);
      userx = await LocalUser().getLocalUser();
      form.user = userx;
      emit(LoadedMainViewState());
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
