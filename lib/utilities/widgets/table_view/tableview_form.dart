import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/textfield_model.dart';
import '../../../modules/inventory_/movements/model/movement_filter_model.dart';

class TableViewFormModel {
  TextfieldModel finder;
  int currentPage;
  int limitPage;
  int totalReg;
  Map filter;

  static int get rows5 => 5;
  static int get rows50 => 50;

  TableViewFormModel({
    required this.finder,
    required this.currentPage,
    required this.limitPage,
    required this.totalReg,
    required this.filter,
  });

  TableViewFormModel.empty()
      : finder = TextfieldModel.empty(),
        currentPage = 0,
        limitPage = 0,
        totalReg = 0,
        filter = {};

  TableViewFormModel.finder(this.finder, {required TableViewFormModel form})
      : currentPage = form.currentPage,
        limitPage = form.limitPage,
        totalReg = form.totalReg,
        filter = form.filter;
}

class TableViewFormCubit extends Cubit<TableViewFormModel> {
  TableViewFormCubit() : super(TableViewFormModel.empty());
}