import 'waybill_list_model.dart';

class WbListFormModel {
  List<WaybillListModel> waybillList;
  int currentPage;
  int totalPages;
  int totalReg;

  WbListFormModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalReg,
    required this.waybillList,
  });

  WbListFormModel.empty()
      : waybillList = [],
        currentPage = 0,
        totalPages = 0,
        totalReg = 0;
}
