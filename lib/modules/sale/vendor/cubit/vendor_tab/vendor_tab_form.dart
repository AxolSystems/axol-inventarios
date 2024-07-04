import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';

class VendorTabForm extends Cubit<TextfieldModel> {
  VendorTabForm() : super(TextfieldModel.empty());

  void setText(String text) {
    final TextfieldModel form = state;
    final TextfieldModel upForm = TextfieldModel(text: text, position: form.position);
    emit(TextfieldModel.empty());
    emit(upForm);
  }

  void setPosition(int position) {
    final TextfieldModel form = state;
    final TextfieldModel upForm = TextfieldModel(text: form.text, position: position);
    emit(TextfieldModel.empty());
    emit(upForm);
  }

  void setForm(TextfieldModel form) {
    final TextfieldModel upForm = form;
    emit(TextfieldModel.empty());
    emit(upForm);
  }
}