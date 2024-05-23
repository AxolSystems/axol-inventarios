import 'package:flutter_bloc/flutter_bloc.dart';

import 'setblock_state.dart';

class SetBlockCubit extends Cubit<SetBlockState> {
  SetBlockCubit() : super(InitialSetBlockState());

  Future<void> initLoad() async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());
      
      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());
      
      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }
}