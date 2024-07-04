import 'package:flutter_bloc/flutter_bloc.dart';

import 'salenote_down_state.dart';

class SaleNoteDownCubit extends Cubit<SaleNoteDownState> {
  SaleNoteDownCubit() : super(InitialSaleNoteDownState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteDownState());
      emit(LoadingSaleNoteDownState());

      emit(LoadedSaleNoteDownState());
    } catch (e) {
      emit(InitialSaleNoteDownState());
      emit(ErrorSaleNoteDownState(error: e.toString()));
    }
  }
}