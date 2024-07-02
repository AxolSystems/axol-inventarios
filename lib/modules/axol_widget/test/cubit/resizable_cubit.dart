import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/resizable_form_model.dart';

enum ResizableState { initial, load }

class ResizableCubit extends Cubit<ResizableState> {
  ResizableCubit() : super(ResizableState.initial);

  void load() {
    emit(ResizableState.initial);
    emit(ResizableState.load);
  }

  void initLoad(ResizableFormModel form) {
    emit(ResizableState.initial);
    form.percent = [0.5, 0.5];
    emit(ResizableState.load);
  }
}

class ResizableForm extends Cubit<ResizableFormModel> {
  ResizableForm() : super(ResizableFormModel.empty());
}
