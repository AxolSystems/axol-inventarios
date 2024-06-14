import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/textfield_model.dart';
import '../../../modules/user/model/user_model.dart';

class TableViewFormModel {
  TextfieldModel finder;
  int currentPage;
  int limitPage;
  int totalReg;
  Map filter;
  UserModel user;

  static int get rows5 => 5;
  static int get rows50 => 50;

  TableViewFormModel({
    required this.finder,
    required this.currentPage,
    required this.limitPage,
    required this.totalReg,
    required this.filter,
    required this.user,
  });

  TableViewFormModel.empty()
      : finder = TextfieldModel.empty(),
        currentPage = 0,
        limitPage = 0,
        totalReg = 0,
        filter = {},
        user = UserModel.empty();

  TableViewFormModel.finder(this.finder, {required TableViewFormModel form})
      : currentPage = form.currentPage,
        limitPage = form.limitPage,
        totalReg = form.totalReg,
        filter = form.filter,
        user = form.user;
}

class TableViewFormCubit extends Cubit<TableViewFormModel> {
  TableViewFormCubit() : super(TableViewFormModel.empty());
}