import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:axol_inventarios/modules/user/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      String idView) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      Map<String, double> widthColumns = {};
      Map<String, String> mapPropsView;
      String propView;
      Map<String, double> propValues = {};

      form.theme = user.theme;

      for (var prop in table.header) {
        widthColumns[prop.key] = 150;
        print(widthColumns[prop.key]);
      }
      
      /*if (user.views.containsKey(idView)) {
        mapPropsView = user.views[idView]!;
        if (mapPropsView.containsKey(UserModel.viewTableColumnWidth)) {
          propView = mapPropsView[UserModel.viewTableColumnWidth]!;
          for (String column in propView.split(',')) {
            propValues[column.split(':').first] =
                double.tryParse(column.split(':').last) ?? 150;
            if (widthColumns.containsKey(column.split(':').first)) {
              widthColumns[column.split(':').first] =
                  double.tryParse(column.split(':').last) ?? 150;
            }
          }
        }
      }*/
      form.columnWidth = widthColumns;
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
