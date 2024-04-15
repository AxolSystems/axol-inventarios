import 'salereport_model.dart';

class SrpDoclistFormModel {
  List<SaleReportModel> saleReportList;
  int currentPage;
  int totalPages;
  int totalReg;

  SrpDoclistFormModel({
    required this.currentPage,
    required this.saleReportList,
    required this.totalPages,
    required this.totalReg,
  });

  SrpDoclistFormModel.empty() :
  saleReportList = [],
  currentPage = 0,
  totalPages = 0,
  totalReg = 0;
}
