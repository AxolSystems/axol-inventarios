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
  Future<void> initLoad(TableFormModel form, int theme) async {
    try {
      emit(InitialTableState());
      form.theme = theme;
      emit(LoadingTableState());

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
