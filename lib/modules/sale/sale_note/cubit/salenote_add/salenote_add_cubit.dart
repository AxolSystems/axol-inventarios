import 'package:flutter_bloc/flutter_bloc.dart';

import 'salenote_add_state.dart';

class SaleNoteAddCubit extends Cubit<SaleNoteAddState> {
  SaleNoteAddCubit() : super(InitialSaleNoteAddState());

  Future<void> load() async {

    try {
      emit(InitialSaleNoteAddState());
      emit(LoadingSaleNoteAddState());
      emit(LoadedSaleNoteAddState(rowFormList: []));
    } catch (e) {
      emit(InitialSaleNoteAddState());
      emit(ErrorSaleNoteAddState(error: e.toString()));
    }
  }
}