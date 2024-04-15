import 'dart:math';

import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:axol_inventarios/modules/user/model/user_mdoel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../model/salereport_model.dart';

class SaleReportRepo {
  static const _table = 'sale_report';
  static const _id = 'id';
  static const _date = 'date';
  static const _user = 'user';
  static const _report = 'report';
  static const _warehouseId = 'warehouse_id';
  static const _warehouseName = 'warehouse_name';
  static const _note = 'note';
  static final _supabase = Supabase.instance.client;

  static Future<DataResponseModel> fetchSaleReportList({
    required UserModel user,
    int? rangeMin,
    int? rangeMax,
  }) async {
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    List<Map<String, dynamic>> saleReportListDB = [];
    List<SaleReportModel> saleReportList = [];
    SaleReportModel saleReport;
    DataResponseModel dataResponse;
    List<ProductModel> productList;
    String conde;
    List<String> codeList;
    final rangeMin_ = rangeMin ?? 0;
    final rangeMax_ = rangeMax ?? 999;

    if (user.rol == UserModel.rolAdmin) {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .order(_date, ascending: false)
          .range(rangeMin_, rangeMax_);
    } else {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*',
              const FetchOptions(count: CountOption.exact))
          .eq(_user, user.id)
          .order(_date, ascending: false)
          .range(rangeMin_, rangeMax_);
    }

    saleReportListDB = postgrestResponse.data ?? [];

    if (saleReportListDB.isNotEmpty) {
      for (var element in saleReportListDB) {

      }
      for (var element in saleReportListDB) {
        saleReport = SaleReportModel(
          id: element[_id],
          date: DateTime.fromMillisecondsSinceEpoch(element[_date] ?? 0),
          warehouse: WarehouseModel(
            id: element[_warehouseId] ?? -1,
            name: element[_warehouseName] ?? '',
            retailManager: user.id,
          ),
          note: element[_note],
          report: SaleReportModel.mapToModel(element[_report], productList),
          user: element[_user],
        );
        saleReportList.add(saleReport);
      }
    }

    dataResponse = DataResponseModel(
        dataList: saleReportList, count: postgrestResponse.count ?? 0);

    return dataResponse;
  }

  static Future<int> fetchAvailableId() async {
    int id = -1;
    int? count;
    List<Map<String, dynamic>> idListDb;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;

    postgrestResponse = await _supabase
        .from(_table)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            _id, const FetchOptions(count: CountOption.exact))
        .limit(1)
        .order(_id, ascending: false);

    idListDb = postgrestResponse.data ?? [];
    count = postgrestResponse.count;

    if (idListDb.isNotEmpty) {
      id = idListDb.first[_id];
      id++;
    } else if (count != null && count < 1) {
      id = 0;
    }

    return id;
  }

  static Future<void> insert(SaleReportModel saleReport) async {
    await _supabase.from(_table).insert({
      _id: saleReport.id,
      _date: saleReport.date.millisecondsSinceEpoch,
      _user: saleReport.user,
      _report: SaleReportModel.modelToMap(saleReport.report), //Convertir a map
      _warehouseId: saleReport.warehouse.id,
      _warehouseName: saleReport.warehouse.name,
      _note: saleReport.note,
    });
  }
}
