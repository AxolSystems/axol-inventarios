import 'package:flutter_bloc/flutter_bloc.dart';

import 'movement_pdf_state.dart';

class MovementPdfCubit extends Cubit<MovementPdfState> {
  MovementPdfCubit() : super(InitialMovePdfState());

  Future<void> load() async {
    try {
      emit(InitialMovePdfState());
      emit(LoadingMovePdfState());
      
      emit(LoadedMovePdfState());
    } catch (e) {
      emit(InitialMovePdfState());
      emit(ErrorMovePdfState(error: e.toString()));
    }
  }
}