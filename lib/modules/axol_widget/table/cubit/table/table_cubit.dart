import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:axol_inventarios/modules/object/model/filter_obj_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/modules/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../../../object/repository/object_repo.dart';
import '../../../../user/repository/user_repo.dart';
import '../../../../widget_link/model/widget_view_model.dart';
import '../../../../widget_link/model/widgetlink_model.dart';
import '../../../../widget_link/repository/widgetlink_repo.dart';
import '../../model/table_form_model.dart';
import 'table_state.dart';

/// Cubit de vista de tabla donde se realiza la lógica
/// del negocio de dicho widget.
class TableCubit extends Cubit<TableState> {
  TableCubit() : super(InitialTableState());

  /// Actualiza la vista de tabla. Este método
  /// es utilizado solo si se requiere recargar
  /// la vista desde TableView.
  Future<void> load() async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Realiza los cambios necesarios en el form para el estado
  /// inicial de la vista de tabla.
  Future<void> initLoad(
      TableFormModel form, WidgetLinkModel link, String viewId) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      Map<String, double> widthColumns = {};
      Map<String, dynamic> columnWidthDB = {};
      final WidgetViewModel view =
          link.views.firstWhere((x) => x.key == viewId);
      final UserModel user = await LocalUser().getLocalUser();

      form.theme = user.theme;
      if (view.properties.containsKey(WidgetViewModel.propNumRows)) {
        form.limitRows = view.properties[WidgetViewModel.propNumRows];
        form.ctrlLimitRow = TextEditingController(
            text: view.properties[WidgetViewModel.propNumRows].toString());
      } else {
        form.limitRows = 50;
        form.ctrlLimitRow = TextEditingController(text: "50");
      }
      form.currentPage = 1;
      await getData(
          form: form, link: link, rangeMin: 0, rangeMax: form.limitRows - 1);
      for (var prop in form.table.header) {
        widthColumns[prop.key] = 150;
      }

      if (view.properties.containsKey(WidgetViewModel.propColumnWidth)) {
        columnWidthDB = view.properties[WidgetViewModel.propColumnWidth];
        for (var prop in form.table.header) {
          if (columnWidthDB.containsKey(prop.key)) {
            widthColumns[prop.key] = columnWidthDB[prop.key];
          }
        }
      }
      form.columnWidth = widthColumns;

      if (view.properties.containsKey(WidgetViewModel.propAscending) &&
          view.properties.containsKey(WidgetViewModel.propKeyAscending)) {
        form.ascending = view.properties[WidgetViewModel.propAscending];
        form.keyAscending = view.properties[WidgetViewModel.propKeyAscending];
      } else {
        form.ascending = false;
        form.keyAscending = null;
      }

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Proceso al presionar botón para editar.
  Future<void> openEdit(TableFormModel form) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      form.edit = true;
      form.ctrlLimitRow =
          TextEditingController(text: form.limitRows.toString());
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Proceso al presionar el botón para inhabilitar el estado de edición.
  Future<void> closeEdit(
      TableFormModel form, WidgetLinkModel link, String keyView) async {
    try {
      emit(InitialTableState());
      emit(SavingTableState());
      int limitRows;
      String saveMessage = 'Cambios de tabla guardados.';
      WidgetLinkModel upLink;
      Map<String, dynamic> properties;
      final WidgetViewModel upView;
      final WidgetViewModel view =
          link.views.firstWhere((x) => x.key == keyView);

      properties = view.properties;
      limitRows = int.parse(form.ctrlLimitRow.text);

      properties[WidgetViewModel.propAscending] = form.ascending;
      properties[WidgetViewModel.propKeyAscending] = form.keyAscending;

      if (limitRows >= 1000) {
        saveMessage =
            'Guardado. Número de filas no guardado, seleccione un número menor a 1000';
      } else {
        properties[WidgetViewModel.propNumRows] = limitRows;
        form.limitRows = limitRows;
      }

      properties[WidgetViewModel.propColumnWidth] = form.columnWidth;
      upView = WidgetViewModel.properties(view, properties);
      upLink = link;
      upLink.views[link.views.indexWhere((x) => x.key == keyView)] = upView;
      await WidgetLinkRepo.updateView(upLink);
      form.edit = false;

      if (((form.currentPage * form.limitRows) - form.limitRows) >
          form.totalReg) {
        form.currentPage = 1;
      }
      await getData(form: form, link: link);

      emit(SavedTableState(saveMessage));
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Procesos al presionar el botón de siguiente página. Si la página
  /// actual se vuelve mayor al total de páginas, después de presionar el
  /// botón, no realiza los procesos.
  Future<void> nextPage(TableFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      if (form.currentPage < form.totalPage) {
        form.currentPage = form.currentPage + 1;
        await getData(form: form, link: link);
      }

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Procesos al presionar el botón de página anterior. Si la página actual
  /// es 1, no realiza los procesos.
  Future<void> prevPage(TableFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      if (form.currentPage > 1) {
        form.currentPage = form.currentPage - 1;
        await getData(form: form, link: link);
      }

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Función para ordenar los datos según la key de la columna recibida.
  Future<void> sort(
      TableFormModel form, String keyAscending, WidgetLinkModel link) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      form.ascending = !form.ascending;
      form.keyAscending = keyAscending;

      await getData(form: form, link: link);

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Si *keyAscending* es diferente a null, vuelve los parámetros filtro de orden
  /// a su estado inicial.
  Future<void> switchSort(TableFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      if (form.keyAscending != null) {
        form.keyAscending = null;
        form.ascending = false;
      }
      await getData(form: form, link: link);
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  ///Función para buscar contenido en barra de búsqueda.
  Future<void> search(TableFormModel form, WidgetLinkModel link) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      await getData(form: form, link: link, search: form.ctrlSearch.text);
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  Future<void> thenFilter(
      TableFormModel form, WidgetLinkModel link, dynamic value) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      if (value is List<FilterObjModel>) {
        form.filters = [];
        for (FilterObjModel flt in value) {
          form.filters.add(flt);
        }
        await getData(form: form, link: link, search: form.ctrlSearch.text);
      }

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }

  /// Método para actualizar los datos de la tabla.
  Future<void> getData({
    required TableFormModel form,
    required WidgetLinkModel link,
    int? rangeMin,
    int? rangeMax,
    String? search,
  }) async {
    final DataResponseModel dataResponse;
    final int countReg;

    rangeMin ??= (form.currentPage * form.limitRows) - form.limitRows;
    rangeMax ??= (form.currentPage * form.limitRows) - 1;

    dataResponse = await ObjectRepo.fetchObject(
      filters: form.filters,
      link: link,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
      ascending: form.ascending,
      keyAscending: form.keyAscending,
      search: search,
    );
    countReg = dataResponse.count;
    form.totalPage = (countReg / form.limitRows).ceil();
    form.totalReg = countReg;
    form.table = TableModel.dataObject(dataResponse, link.entity);
    form.referenceLinks =
        dataResponse.dynamicValues?[ReferenceObjectModel.tRefLink] ?? [];
  }
}

/// Cubit que contiene el estado actual del form de la
/// vista de tabla.
class TableForm extends Cubit<TableFormModel> {
  TableForm() : super(TableFormModel.empty());
}
