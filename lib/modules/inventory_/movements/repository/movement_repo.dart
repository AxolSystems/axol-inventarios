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
  static const String _warehouse = 'warehouse';
  static const String _concept = 'concept';
  static const String _conceptType = 'concept_type';
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
        _warehouse: element.warehouse,
        _concept: element.concept,
        _conceptType: element.conceptType,
        _quantity: element.quantity,
        _user: element.user,
        _stock: element.stock,
      });
    }
  }

  Future<MovementResponseModel> fetchMovements(
      {String? find,
      int? rangeMin,
      int? rangeMax,
      MovementFilterModel? filter}) async {
    List<MovementModel> movements = [];
    final MovementResponseModel movementResponse;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    MovementModel move;
    //int filterLimit = 50;
    int initDateInt = 0;
    int endDateInt = 32503708800000;
    Map<String, dynamic> match = {};
    List<Map<String, dynamic>> movementsDB = [];
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    MovementFilterModel filter_ = filter ?? MovementFilterModel.empty();

    /*if (moveFilter_.warehouse.id > -1) {
      filters[_warehouse] = moveFilter_.warehouse.name;
      //print(filters[_warehouse].warehouse as MovementFilterModel);
    }*/
    /*if (moveFilter_.date[0]!.year != 0) {
      filterStartDate = moveFilter_.date[0]!.millisecondsSinceEpoch;
      filterEndDate = moveFilter_.date[1]!.millisecondsSinceEpoch;
    }*/
    /*if (moveFilter_.concept.id != -1) {
      filters[_concept] = moveFilter_.concept.id;
    }
    if (moveFilter_.user.id != -1) {
      filters[_user] = moveFilter_.user.name;
    }
    if (moveFilter_.currentLimit.text != '50') {
      filterLimit = int.parse(moveFilter_.currentLimit.text);
    }*/
    /*if (filter == null || filter == '') {
    } else {
      if (mode == 1) {
        postgrestResponse = await _supabase
            .from(_table)
            .select<PostgrestResponse<List<Map<String, dynamic>>>>()
            .or('$_code.ilike.%$filter%,$_description.ilike.%$filter%,$_document.ilike.%$filter%')
            .match(filters)
            .lte(_time, filterEndDate)
            .gte(_time, filterStartDate)
            .order(_time, ascending: true)
            .limit(filterLimit);
      } else {
        postgrestResponse = await _supabase
            .from(_table)
            .select<PostgrestResponse<List<Map<String, dynamic>>>>()
            .or('$_code.ilike.%$filter%,$_description.ilike.%$filter%,$_document.ilike.%$filter%')
            .match(filters)
            .lte(_time, filterEndDate)
            .gte(_time, filterStartDate)
            .order(_time, ascending: true)
            .limit(filterLimit);
      }
    }*/

    if (filter_.warehouse.name != '') {
      match[_warehouse] = filter_.warehouse.name;
    }
    if (filter_.filterDate == true ) {
      initDateInt = filter_.initDate.millisecondsSinceEpoch;
      endDateInt = filter_.endDate.millisecondsSinceEpoch;
    }

    postgrestResponse = await _supabase
        .from(_table)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.exact))
        .match(match)
        .lte(_time, endDateInt)
        .gte(_time, initDateInt)
        .order(_time, ascending: true)
        .range(rangeMin_, rangeMax_);

    movementsDB = postgrestResponse.data ?? [];

    if (movementsDB.isNotEmpty) {
      for (var element in movementsDB) {
        move = MovementModel(
            id: element[_id].toString(),
            code: element[_code].toString(),
            concept: element[_concept],
            conceptType: element[_conceptType],
            description: element[_description].toString(),
            document: element[_document].toString(),
            quantity: element[_quantity],
            time:
                DateTime.fromMillisecondsSinceEpoch(int.parse(element[_time])),
            warehouse: element[_warehouse].toString(),
            user: element[_user].toString(),
            stock: element[_stock],
            folio: element[_folio] ?? -1);
        movements.add(move);
      }
    }
    movementResponse = MovementResponseModel(
        movementList: movements, count: postgrestResponse.count ?? 0);
    return movementResponse;
  }
}
