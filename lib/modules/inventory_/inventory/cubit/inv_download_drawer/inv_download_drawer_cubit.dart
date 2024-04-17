import 'package:flutter_bloc/flutter_bloc.dart';

import 'inv_download_drawer_state.dart';

class InvDownloadDrawerCubit extends Cubit<InvDownloadDrawerState> {
  InvDownloadDrawerCubit() : super(InitialInvDownloadDrawerState());

  Future<void> load() async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }

  Future<void> saveCsv() async {
    try {
      emit(InitialInvDownloadDrawerState());
      emit(LoadingInvDownloadDrawerState());

      emit(LoadedInvDownloadDrawerState());
    } catch (e) {
      emit(InitialInvDownloadDrawerState());
      emit(ErrorInvDownloadDrawerState(error: e.toString()));
    }
  }
}