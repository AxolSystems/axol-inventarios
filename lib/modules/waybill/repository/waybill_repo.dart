import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/waybill_list_model.dart';

class WayBillRepo {
  final String _table = 'waybill_lists';
  final String _id = 'id';
  final String _list = 'list';
  final String _warehouseId = 'warehouse_id';
  final String _warehouseName = 'warehouse_name';
  final String _manager = 'manager';
  final String _date = 'date';
  final _supabase = Supabase.instance.client;

  Future<List<WaybillListModel>> fetchLists({
    required int manager,
    int? rangeMin,
    int? rangeMax,
  }) async {
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    List<Map<String, dynamic>> waybillListDB;
    List<WaybillListModel> waybillList = [];
    WaybillListModel waybill;
    final rangeMin_ = rangeMin ?? 0;
    final rangeMax_ = rangeMax ?? 999;

    postgrestResponse = await _supabase
        .from(_table)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '$_id, $_warehouseId, $_warehouseName, $_date',
            const FetchOptions(count: CountOption.exact))
        .eq(_manager, manager)
        .order(_date, ascending: false)
        .range(rangeMin_, rangeMax_);

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

    return waybillList;
  }
}
