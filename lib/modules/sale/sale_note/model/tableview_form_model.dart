import '../../../../models/textfield_model.dart';

class TableViewFormModel {
  TextfieldModel finder;
  int currentPage;
  int limitPage;
  int totalReg;

  static int get rows5 => 5;
  static int get rows50 => 50;

  TableViewFormModel({
    required this.finder,
    required this.currentPage,
    required this.limitPage,
    required this.totalReg,
  });

  TableViewFormModel.empty()
      : finder = TextfieldModel.empty(),
        currentPage = 0,
        limitPage = 0,
        totalReg = 0;

  TableViewFormModel.finder(this.finder, {required TableViewFormModel form})
      : currentPage = form.currentPage,
        limitPage = form.limitPage,
        totalReg = form.totalReg;
}
