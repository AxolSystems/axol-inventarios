import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../block/model/block_model.dart';
import '../../block/model/property_model.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';

class ObjectRepo {
  static const String _id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static final _supabase = Supabase.instance.client;

  /// Obtiene una lista de objetos de la base de datos.
  ///
  /// Recibe un [BlockModel] : [block] y una lista [FilterObjModel] : [filterList].
  /// Si [filterList] no se encuentra vacía, realiza una búsqueda filtrada; de lo contrario,
  /// realiza una búsqueda completa de la tabla referenciada. La tabla de la base de datos donde
  /// se hará la búsqueda es obtenida mediante [BlockModel.tableName].
  ///
  /// Después de la consulta convierte los datos obtenidos en una lista [ObjectModel].
  static Future<DataResponseModel> fetchObject({
    required List<FilterObjModel> filterList,
    required WidgetLinkModel link,
    int? rangeMin,
    int? rangeMax,
    bool? ascending,
    String? keyAscending,
    String? search,
  }) async {
    List<Map<String, dynamic>> objsDB;
    List<ObjectModel> objList = [];
    ObjectModel obj;
    Map<String, dynamic> matchMap = {};
    String textOr = '';
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    final bool ascending_ = ascending ?? false;
    final String keyAscending_;
    final DataResponseModel dataResponse;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;

    if (keyAscending == null) {
      keyAscending_ = _createAt;
    } else {
      keyAscending_ = '$_object->"$keyAscending"';
    }

    if (search != null) {
      for (int i = 0; i < link.block.propertyList.length; i++) {
        final PropertyModel prop = link.block.propertyList[i];
        if (i == 0) {
          textOr = '$_object->>"${prop.key}".ilike.%$search%';
        } else {
          textOr = '$textOr,$_object->>"${prop.key}".ilike.%$search%';
        }
        /*if (i < (link.block.propertyList.length - 1)) {
          textOr = '$textOr,';
        }*/
      }
      //textOr = '$_name.ilike.%$inText%';
    }

    if (filterList.isNotEmpty) {
      for (var flt in filterList) {
        if (flt.filter == FilterOperator.eq) {
          matchMap[flt.property.name] = flt.value;
        }
      }
      postgrestResponse = await _supabase
          .from(link.block.tableName)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.estimated))
          .match(matchMap)
          .range(rangeMin_, rangeMax_)
          .order(keyAscending_, ascending: ascending_);
    } else if (search != null) {
      postgrestResponse = await _supabase
          .from(link.block.tableName)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.estimated))
          .or(textOr)
          .range(rangeMin_, rangeMax_)
          .order(keyAscending_, ascending: ascending_);
    } else {
      postgrestResponse = await _supabase
          .from(link.block.tableName)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.estimated))
          //.or(textOr)
          .range(rangeMin_, rangeMax_)
          .order(keyAscending_, ascending: ascending_);
    }

    objsDB = postgrestResponse.data ?? [];

    if (objsDB.isNotEmpty) {
      for (var objDB in objsDB) {
        obj = ObjectModel(
          id: objDB[_id],
          map: objDB[_object],
          createAt: DateTime.parse(objDB[_createAt]),
        );
        objList.add(obj);
      }
    }

    dataResponse = DataResponseModel(
      dataList: objList,
      count: postgrestResponse.count ?? 0,
    );

    return dataResponse;
  }
}
