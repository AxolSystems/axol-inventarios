import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/tableview_form_model.dart';

class CustomerTabForm extends Cubit<TableViewFormModel> {
  CustomerTabForm() : super(TableViewFormModel.empty());
  
  void setForm(TableViewFormModel form) {
    final TableViewFormModel upForm = form;
    emit(TableViewFormModel.empty());
    emit(upForm);
  }
}