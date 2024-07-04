import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modulebar_state.dart';

class ModuleBarCubit extends Cubit<ModuleBarState> {
  ModuleBarCubit() : super(InitialModuleBarState());

  Future<void> initLoad() async {
    try {
      emit(InitialModuleBarState());
      emit(LoadingModuleBarState());
      emit(const LoadedModuleBarState());
    } catch (e) {
      emit(InitialModuleBarState());
      emit(ErrorModuleBarState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialModuleBarState());
      emit(LoadingModuleBarState());

      emit(const LoadedModuleBarState());
    } catch (e) {
      emit(InitialModuleBarState());
      emit(ErrorModuleBarState(error: e.toString()));
    }
  }

  Future<void> setColor(Color color) async {
    try {
      emit(InitialModuleBarState());
      emit(LoadingModuleBarState());

      emit(LoadedModuleBarState(color: color));
    } catch (e) {
      emit(InitialModuleBarState());
      emit(ErrorModuleBarState(error: e.toString()));
    }
  }
}