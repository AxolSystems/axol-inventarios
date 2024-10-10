import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:axol_inventarios/modules/axol_widget/generic/repository/widget_index.dart';
import 'package:axol_inventarios/modules/user/model/user_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widget_view_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../axol_widget/generic/view/axol_widget.dart';
import '../../../entity/view/setentity_widget.dart';
import '../../../module/view/set_module_widget.dart';
import '../../../object/repository/object_repo.dart';
import '../../../user/repository/user_repo.dart';
import '../../model/main_view_form_model.dart';
import '../../../module/model/module_model.dart';
import '../../../module/repository/module_repo.dart';
import 'mainview_state.dart';

class MainViewCubit extends Cubit<MainViewState> {
  MainViewCubit() : super(InitialMainViewState());

  /// Lógica inicial al construir MainView.
  ///
  /// 1. Obtiene datos locales del usuario y guarda [MainViewFormModel.user].
  /// 2. Busca en [ModuleRepo] lista de módulos.
  /// 3. Si lista de módulos no se encuentra vacía, y contiene links y views,
  /// selecciona primer view de la lista para mostrar su widget.
  /// 4. Busca objetos relacionados a widgetLink.
  /// 5. Guarda y actualiza datos obtenidos en [form].
  Future<void> initLoad(MainViewFormModel form) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final List<ModuleModel> moduleList;
      final ModuleModel module;
      final AxolWidget axolWidget;
      final DataResponseModel dataResponse;
      final WidgetLinkModel link;
      final WidgetViewModel view;
      const int rangeMin = 0; 
      final int rangeMax;

      form.user = await LocalUser().getLocalUser();

      moduleList = await ModuleRepo.fetchModuleList();
      await ModuleRepo.fetchModulesPostgres();

      if (moduleList.isNotEmpty) {
        module = moduleList[0];
        if (module.widgetLinks.isNotEmpty) {
          link = module.widgetLinks.first;
          if (link.views.isNotEmpty) {
            view = link.views.first;
          } else {
            view = WidgetViewModel.empty();
          }

          if (link.views.first.properties
              .containsKey(WidgetViewModel.propNumRows)) {
            rangeMax = link.views.first.properties[WidgetViewModel.propNumRows] - 1;
          } else {
            rangeMax = 49;
          }

          /*dataResponse = await ObjectRepo.fetchObject(
              view.filterList, link, rangeMin, rangeMax);*/
          axolWidget = WidgetIndex.widget(
            i: link.widget,
            //data: WidgetIndex.data(link.widget, dataResponse, link.entity),
            user: form.user,
            link: link,
            viewId: link.views.first.key,
          );
          form.title = moduleList.first.name;
        } else {
          axolWidget = const EmptyWidget();
          link = WidgetLinkModel.empty();
          //objects = [];
        }
        form.moduleList = moduleList;
        form.moduleSelect = 0;
        form.body = axolWidget;
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  /// Función para recargar MainView.
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

  /// Lógica para cambio de widgetLink.
  ///
  /// 1. Busca objetos mediante view seleccionado.
  /// 2. Si widgetLink o widgetView anterior son diferentes al actual seleccionado,
  /// actualiza widget y titulo.
  Future<void> setWidgetLink(
      MainViewFormModel form, int indexLink, int indexView) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final ModuleModel module;
      final WidgetLinkModel link;
      final WidgetViewModel view;
      final DataResponseModel dataResponse;
      const int rangeMin = 0;
      final int rangeMax;

      module = form.moduleList[form.moduleSelect];
      if (module.widgetLinks.isNotEmpty) {
        link = module.widgetLinks[indexLink];
        if (link.views.isNotEmpty) {
          view = link.views[indexView];
        } else {
          view = WidgetViewModel.empty();
        }

        if (link.views[indexView].properties
            .containsKey(WidgetViewModel.propNumRows)) {
          rangeMax =
              link.views[indexView].properties[WidgetViewModel.propNumRows] - 1;
        } else {
          rangeMax = 49;
        }
        /*dataResponse = await ObjectRepo.fetchObject(
            view.filterList, link, rangeMin, rangeMax);*/
        if (form.linkSelect != indexLink || form.viewSelect != indexView) {
          form.linkSelect = indexLink;
          form.viewSelect = indexView;
          form.body = WidgetIndex.widget(
            i: link.widget,
            //data: WidgetIndex.data(link.widget, dataResponse, link.entity),
            user: form.user,
            link: link,
            viewId: link.views[indexView].key,
          );
        }
        form.title = module.name;
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  /// Lógica de cambio de módulos.
  ///
  /// 1. Obtiene link y view de [form] según el modulo seleccionado.
  /// 2. Busca en [ObjectRepo] los objetos indicados por link y view.
  /// 3. Actualiza datos de [form].
  Future<void> setModule(MainViewFormModel form, int indexModule) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());
      final DataResponseModel dataResponse;
      final ModuleModel module;
      final WidgetLinkModel link;
      final WidgetViewModel view;
      const int rangeMin = 0;
      final int rangeMax;

      if (indexModule != form.moduleSelect) {
        form.moduleSelect = indexModule;
        module = form.moduleList[indexModule];
        if (module.widgetLinks.isNotEmpty) {
          link = module.widgetLinks.first;
          if (link.views.isNotEmpty) {
            view = link.views.first;
          } else {
            view = WidgetViewModel.empty();
          }

          if (link.views.first.properties
              .containsKey(WidgetViewModel.propNumRows)) {
            rangeMax = link.views.first.properties[WidgetViewModel.propNumRows] - 1;
          } else {
            rangeMax = 49;
          }
          /*dataResponse = await ObjectRepo.fetchObject(
              view.filterList, link, rangeMin, rangeMax);*/
          form.linkSelect = 0;
          form.viewSelect = 0;
          form.body = WidgetIndex.widget(
            i: link.widget,
            //data: WidgetIndex.data(link.widget, dataResponse, link.entity),
            user: form.user,
            link: link,
            viewId: link.views.first.key,
          );
          form.title = module.name;
        }
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  /// Carga el widget para configurar bloques desde [SetEntityWidget].
  Future<void> setSetting(MainViewFormModel form, int linkSelect) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());

      if (linkSelect == 0) {
        form.body = SetEntityWidget(theme: form.user.theme);
        if (form.linkSelect != 0) {
          form.linkSelect = 0;
        }
      } else if (linkSelect == 1) {
        form.body = SetModuleWidget(theme: form.user.theme);
        if (form.linkSelect != 1) {
          form.linkSelect = 1;
        }
      }

      emit(LoadedMainViewState());
    } catch (e) {
      emit(InitialMainViewState());
      emit(ErrorMainViewState(error: e.toString()));
    }
  }

  /// Actualiza el tema seleccionado.
  Future<void> setTheme(
      UserModel user, int theme, MainViewFormModel form) async {
    try {
      emit(InitialMainViewState());
      emit(LoadingMainViewState());

      await DatabaseUser().updateTheme(user.id, theme);
      await LocalUser().setTheme(theme);
      form.user = await LocalUser().getLocalUser();

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
