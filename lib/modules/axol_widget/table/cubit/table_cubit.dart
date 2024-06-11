import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/table_form_model.dart';
import 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(InitialTableState());

  Future<void> load() async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());

      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> initLoad(TableFormModel form, int theme) async {
    try {
      emit(InitialTableState());
      emit(LoadingTableState());
      form.theme = theme;
      emit(LoadedTableState());
    } catch (e) {
      emit(InitialTableState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }
}

class TableForm extends Cubit<TableFormModel> {
  TableForm() : super(TableFormModel.empty());
}
