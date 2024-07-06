import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:axol_inventarios/modules/user/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget_link/model/widget_view_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../../../widget_link/repository/widgetlink_repo.dart';
import '../model/table_form_model.dart';
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
  Future<void> initLoad(TableFormModel form, TableModel table, UserModel user,
      WidgetLinkModel link, String viewId) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      Map<String, double> widthColumns = {};
      Map<String, dynamic> columnWidthDB = {};
      final WidgetViewModel view =
          link.views.firstWhere((x) => x.key == viewId);

      form.theme = user.theme;

      for (var prop in table.header) {
        widthColumns[prop.key] = 150;
      }

      if (view.properties.containsKey(WidgetViewModel.propColumnWidth)) {
        columnWidthDB = view.properties[WidgetViewModel.propColumnWidth];
        for (var prop in table.header) {
          if (columnWidthDB.containsKey(prop.key)) {
            widthColumns[prop.key] = columnWidthDB[prop.key];
          }
        }
      }

      form.columnWidth = widthColumns;
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
      WidgetLinkModel upLink;
      Map<String, dynamic> properties;
      final WidgetViewModel upView;
      final WidgetViewModel view =
          link.views.firstWhere((x) => x.key == keyView);

      properties = view.properties;
      properties[WidgetViewModel.propColumnWidth] = form.columnWidth;
      upView = WidgetViewModel.properties(view, properties);
      upLink = link;
      upLink.views[link.views.indexWhere((x) => x.key == keyView)] = upView;
      await WidgetLinkRepo.updateView(upLink);

      form.edit = false;

      emit(SavedTableState());
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorTableState(error: e.toString()));
    }
  }
}

/// Cubit que contiene el estado actual del form de la
/// vista de tabla.
class TableForm extends Cubit<TableFormModel> {
  TableForm() : super(TableFormModel.empty());
}
