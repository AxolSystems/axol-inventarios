import 'package:flutter_bloc/flutter_bloc.dart';

import 'salenote_note_state.dart';

class SaleNoteNoteCubit extends Cubit<SaleNoteNoteState> {
  SaleNoteNoteCubit() : super(InitialSaleNoteNoteState());

  Future<void> load() async {
    try {
      emit(InitialSaleNoteNoteState());
      emit(LoadingSaleNoteNoteState());
      emit(LoadedSaleNoteNoteState());
    } catch (e) {
      emit(InitialSaleNoteNoteState());
      emit(ErrorSaleNoteNoteState(error: e.toString()));
    }
  }
}
