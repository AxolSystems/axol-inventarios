import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/table_view/tableview_form.dart';

class CustomerTabForm extends Cubit<TableViewFormModel> {
  CustomerTabForm() : super(TableViewFormModel.empty());
  
  void setForm(TableViewFormModel form) {
    final TableViewFormModel upForm = form;
    emit(TableViewFormModel.empty());
    emit(upForm);
  }
}