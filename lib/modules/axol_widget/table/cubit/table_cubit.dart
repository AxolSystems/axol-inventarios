import 'package:flutter_bloc/flutter_bloc.dart';

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
}