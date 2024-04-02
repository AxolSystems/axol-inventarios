import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/movement_filter_model.dart';
import '../model/movement_model.dart';
import '../model/movement_response_model.dart';

class MovementRepo {
  //Table
  static const String _table = 'movement_history';
  //Columns movement_history
  static const String _id = 'id';
  static const String _time = 'time';
  static const String _code = 'code';
  static const String _description = 'description';
  static const String _document = 'document';
  static const String _warehouseName = 'warehouse_name';
  static const String _warehouseId = 'warehouse_id';
  static const String _concept = 'concept';
  static const String _conceptType = 'concept_type';
  static const String _conceptName = 'concept_name';
  static const String _quantity = 'quantity';
  static const String _user = 'user';
  static const String _stock = 'stock';
  static const String _folio = 'folio_number';
  //Database
  static final _supabase = Supabase.instance.client;

  Future<void> insertMovemets(List<MovementModel> newMovements) async {
    for (var element in newMovements) {
      await _supabase.from(_table).insert({
        _id: element.id,
        _time: element.time.millisecondsSinceEpoch,
        _code: element.code,
        _description: element.description,
        _document: element.document,
        _warehouseName: element.warehouseName,
        _warehouseId: element.warehouseId,
        _concept: element.concept,
        _conceptType: element.conceptType,
        _conceptName: element.conceptName,
        _quantity: element.quantity,
        _user: element.user,
        _stock: element.stock,
        _folio: element.folio,
      });
    }
  }

  Future<MovementResponseModel> fetchMovements(
      {String? find,
      int? rangeMin,
      int? rangeMax,
      MovementFilterModel? filter,
      bool? isFilterConcept}) async {
    List<MovementModel> movements = [];
    final MovementResponseModel movementResponse;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    MovementModel move;
    int initDateInt = 0;
    int endDateInt = 32503708800000;
    Map<String, dynamic> match = {};
    List<Map<String, dynamic>> movementsDB = [];
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    MovementFilterModel filter_ = filter ?? MovementFilterModel.empty();

    if (filter_.warehouse.name != '') {
      match[_warehouseName] = filter_.warehouse.name;
    }
    if (filter_.filterDate == true) {
      initDateInt = filter_.initDate.millisecondsSinceEpoch;
      endDateInt = filter_.endDate.millisecondsSinceEpoch;
    }
    if (filter_.folio.isNotEmpty) {
      match[_folio] = filter_.folio.first;
    }
    if (filter_.document.isNotEmpty) {
      match[_document] = filter_.document.first;
    }

    if (isFilterConcept == true) {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .match(match)
          .in_(_concept, filter_.concept)
          .lte(_time, endDateInt)
          .gte(_time, initDateInt)
          .order(_time, ascending: false)
          .range(rangeMin_, rangeMax_);
    } else {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .match(match)
          .lte(_time, endDateInt)
          .gte(_time, initDateInt)
          .order(_time, ascending: false)
          .range(rangeMin_, rangeMax_);
    }

    movementsDB = postgrestResponse.data ?? [];

    if (movementsDB.isNotEmpty) {
      for (var element in movementsDB) {
        move = MovementModel(
            id: element[_id].toString(),
            code: element[_code].toString(),
            concept: element[_concept] ?? -1,
            conceptType: element[_conceptType] ?? -1,
            conceptName: element[_conceptName] ?? '',
            description: element[_description] ?? '',
            document: element[_document] ?? '',
            quantity: element[_quantity] ?? -1,
            time: DateTime.fromMillisecondsSinceEpoch(element[_time]),
            warehouseName: element[_warehouseName] ?? '',
            warehouseId: element[_warehouseId] ?? -1,
            user: element[_user] ?? '',
            stock: element[_stock] ?? -1,
            folio: element[_folio] ?? -1);

        movements.add(move);
      }
    }

    movementResponse = MovementResponseModel(
        movementList: movements, count: postgrestResponse.count ?? 0);
    return movementResponse;
  }

  Future<int> fetchAvailableFolio() async {
    List<Map<String, dynamic>> movementDB = [];
    int newFolio = -1;

    movementDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>(_folio)
        .order(_folio, ascending: false)
        .limit(1);

    if (movementDB.isNotEmpty) {
      newFolio = int.tryParse(movementDB.first[_folio].toString()) ?? -1;
      if (newFolio > -1) {
        newFolio++;
      }
    }
    return newFolio;
  }

  Future<List<int>> fetchAvailableFolioList(int qty) async {
    List<Map<String, dynamic>> movementDB = [];
    List<int> folioList = [];
    int folio = -1;

    movementDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>(_folio)
        .order(_folio, ascending: false)
        .limit(qty);

    if (movementDB.isNotEmpty) {
      for (var element in movementDB) {
        folio = int.tryParse(element[_folio].toString()) ?? -1;
        if (folio > -1) {
          folio++;
          folioList.add(folio);
        }
      }
    }
    return folioList;
  }
}
