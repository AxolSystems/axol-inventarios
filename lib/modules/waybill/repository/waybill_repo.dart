import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../../models/inventory_row_model.dart';
import '../../inventory_/product/model/product_model.dart';
import '../../inventory_/product/repository/product_repo.dart';
import '../model/waybill_list_model.dart';

class WaybillRepo {
  static const String _table = 'waybill_lists';
  static const String _id = 'id';
  static const String _list = 'list';
  static const String _warehouseId = 'warehouse_id';
  static const String _warehouseName = 'warehouse_name';
  static const String _manager = 'manager';
  static const String _date = 'date';
  static final _supabase = Supabase.instance.client;

  static Future<DataResponseModel> fetchLists({
    required int manager,
    int? rangeMin,
    int? rangeMax,
  }) async {
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    List<Map<String, dynamic>> waybillListDB;
    List<WaybillListModel> waybillList = [];
    WaybillListModel waybill;
    DataResponseModel dataResponse;
    final rangeMin_ = rangeMin ?? 0;
    final rangeMax_ = rangeMax ?? 999;

    if (manager == -2) {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '$_id, $_warehouseId, $_warehouseName, $_date',
              const FetchOptions(count: CountOption.exact))
          .order(_date, ascending: false)
          .range(rangeMin_, rangeMax_);
    } else {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '$_id, $_warehouseId, $_warehouseName, $_date',
              const FetchOptions(count: CountOption.exact))
          .eq(_manager, manager)
          .order(_date, ascending: false)
          .range(rangeMin_, rangeMax_);
    }

    waybillListDB = postgrestResponse.data ?? [];

    if (waybillListDB.isNotEmpty) {
      for (var element in waybillListDB) {
        waybill = WaybillListModel.emptyList(
          id: element[_id],
          date: DateTime.fromMillisecondsSinceEpoch(element[_date] ?? 0),
          warehouse: WarehouseModel(
            id: element[_warehouseId] ?? -1,
            name: element[_warehouseName] ?? '',
            retailManager: manager,
          ),
        );
        waybillList.add(waybill);
      }
    }

    dataResponse = DataResponseModel(
        dataList: waybillList, count: postgrestResponse.count ?? 0);

    return dataResponse;
  }

  static Future<List<InventoryRowModel>> fetchWaybill(int id) async {
    List<InventoryRowModel> waybillList = [];
    InventoryRowModel waybill;
    List<Map<String, dynamic>> waybillListDB;
    Map<String, dynamic> waybillDB;
    List<ProductModel> productList;
    List<String> codeList = [];
    ProductModel product;

    waybillListDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>(_list)
        .eq(_id, id);

    if (waybillListDB.isNotEmpty) {
      waybillDB = waybillListDB.first[_list];
      if (waybillDB.isNotEmpty) {
        for (String value in waybillDB.values) {
          codeList.add(value.split('~').first);
        }
        productList = await ProductRepo().fetchProductListCode(codeList);
        for (String element in waybillDB.values) {
          product =
              productList.where((x) => x.code == element.split('~')[0]).first;
          waybill = InventoryRowModel(
            product: product,
            stock: double.tryParse(element.split('~')[1]) ?? 0,
            warehouseName: element.split('~')[2],
          );
          waybillList.add(waybill);
        }
      }
    }

    return waybillList;
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

  static Future<void> insert(WaybillListModel waybillList) async {
    await _supabase.from(_table).insert({
      _id: waybillList.id,
      _list: InventoryRowModel.rowToMapWaybill(waybillList.list),
      _warehouseId: waybillList.warehouse.id,
      _warehouseName: waybillList.warehouse.name,
      _date: waybillList.date.millisecondsSinceEpoch,
      _manager: waybillList.warehouse.retailManager,
    });
  }
}
