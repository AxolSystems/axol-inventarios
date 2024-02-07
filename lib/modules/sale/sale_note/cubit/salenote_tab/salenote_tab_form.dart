import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../model/tableview_form_model.dart';

class SaleNoteTabForm extends Cubit<TableViewFormModel> {
  SaleNoteTabForm() : super(TableViewFormModel.empty());

  void setText(String text) {
    final TableViewFormModel form = state;
    final TableViewFormModel upForm = TableViewFormModel(
        finder: TextfieldModel(text: text, position: form.finder.position),
        currentPage: form.currentPage,
        limitPage: form.limitPage,
        totalReg: form.totalReg);
    emit(TableViewFormModel.empty());
    emit(upForm);
  }

  void setPosition(int position) {
    final TableViewFormModel form = state;
    final TableViewFormModel upForm = TableViewFormModel(
        finder: TextfieldModel(text: form.finder.text, position: position),
        currentPage: form.currentPage,
        limitPage: form.limitPage,
        totalReg: form.totalReg);
    emit(TableViewFormModel.empty());
    emit(upForm);
  }

  void setForm(TableViewFormModel form) {
    final TableViewFormModel upForm = form;
    emit(TableViewFormModel.empty());
    emit(upForm);
  }
}
