import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../entity/model/entity_model.dart';
import '../../entity/model/property_model.dart';
import '../../entity/repository/entity_repo.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';

class ObjectRepo {
  static const String id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static final _supabase = Supabase.instance.client;

  /// Obtiene una lista de objetos de la base de datos.
  ///
  /// Recibe un [EntityModel] : [entity] y una lista [FilterObjModel] : [filters].
  /// Si [filters] no se encuentra vacía, realiza una búsqueda filtrada; de lo contrario,
  /// realiza una búsqueda completa de la tabla referenciada. La tabla de la base de datos donde
  /// se hará la búsqueda es obtenida mediante [EntityModel.tableName].
  ///
  /// Después de la consulta convierte los datos obtenidos en una lista [ObjectModel].
  static Future<DataResponseModel> fetchObject({
    required List<FilterObjModel> filters,
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
      if (search.contains(':')) {
        final String key = link.entity.propertyList
            .firstWhere(
              (x) => x.name == search.split(':').first,
              orElse: () => PropertyModel.empty(),
            )
            .key;
        if (search.split(':').last.contains(',')) {
          for (int i = 0; i < search.split(':').last.split(',').length; i++) {
            final String element =
                search.split(':').last.split(',').elementAt(i);
            if (i == 0) {
              textOr = '$_object->>"$key".ilike.%$element%';
            } else {
              textOr = '$textOr,$_object->>"$key".ilike.%$element%';
            }
          }
        } else {
          textOr = '$_object->>"$key".ilike.%${search.split(':').last}%';
        }
      } else {
        for (int i = 0; i < link.entity.propertyList.length; i++) {
          final PropertyModel prop = link.entity.propertyList[i];
          if (i == 0) {
            textOr = '$_object->>"${prop.key}".ilike.%$search%';
          } else {
            textOr = '$textOr,$_object->>"${prop.key}".ilike.%$search%';
          }
        }
      }
    }

    var query = _supabase
        .from(link.entity.tableName)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.estimated));

    if (search != null) {
      query = query.or(textOr);
    }

    for (FilterObjModel filter in filters) {
      if (filter.operator == FilterOperator.eq) {
        query = query.eq('$_object->>"${filter.property.key}"', filter.value);
      }
      if (filter.operator == FilterOperator.like) {
        query = query.like(
            '$_object->>"${filter.property.key}"', '%${filter.value}%');
      }
      if (filter.operator == FilterOperator.ilike) {
        query = query.ilike(
            '$_object->>"${filter.property.key}"', '%${filter.value}%');
      }
      if (filter.operator == FilterOperator.gt) {
        query = query.gt('$_object->>"${filter.property.key}"', filter.value);
      }
      if (filter.operator == FilterOperator.gte) {
        query = query.gte('$_object->>"${filter.property.key}"', filter.value);
      }
      if (filter.operator == FilterOperator.lt) {
        query = query.lt('$_object->>"${filter.property.key}"', filter.value);
      }
      if (filter.operator == FilterOperator.lte) {
        query = query.lte('$_object->>"${filter.property.key}"', filter.value);
      }
      if (filter.operator == FilterOperator.neq) {
        query = query.neq('$_object->>"${filter.property.key}"', filter.value);
      }
    }

    postgrestResponse = await query
        .range(rangeMin_, rangeMax_)
        .order(keyAscending_, ascending: ascending_);

    objsDB = postgrestResponse.data ?? [];

    if (objsDB.isNotEmpty) {
      List<String> idObjects = [];
      List<String> idEntities = [];
      List<PropertyModel> propsRef = [];
      List<ReferenceObjectModel> objsRef = [];

      for (var prop in link.entity.propertyList) {
        if (prop.propertyType == Prop.referenceObject) {
          propsRef.add(prop);
          if (!idEntities
              .contains(prop.dynamicValues[PropertyModel.dvRefEntity])) {
            idEntities.add(prop.dynamicValues[PropertyModel.dvRefEntity]);
          }
          for (var objDB in objsDB) {
            final String? idObject =
                objDB[_object][prop.key][ReferenceObjectModel.object];
            if (idObject != null && idObject != '') {
              idObjects.add(idObject);
            }
          }
        }
      }

      if (idEntities.isNotEmpty) {
        final List<EntityModel> entityRefList =
            await EntityRepo.fetchEntities(idEntities);
        for (EntityModel entity in entityRefList) {
          //mapObjRef[entity.uuid] =
          final List<Map<String, dynamic>> objRefDb = await _supabase
              .from(entity.tableName)
              .select<List<Map<String, dynamic>>>()
              .in_(id, idObjects);
          for (Map<String, dynamic> element in objRefDb) {
            objsRef.add(ReferenceObjectModel(
              idEntity: entity.uuid,
              referenceObject: ObjectModel(
                  createAt: DateTime.parse(element[_createAt]),
                  id: element[id],
                  map: element[_object]),
              propertyList: entity.propertyList,
              idPropertyView: '',
            ));
          }
        }
      }

      for (Map<String, dynamic> objDB in objsDB) {
        final Map<String, dynamic> objMap = objDB[_object];

        for (PropertyModel prop in propsRef) {
          final ReferenceObjectModel refObj;
          final String idObjRef;
          if (objMap.containsKey(prop.key)) {
            idObjRef = objMap[prop.key][ReferenceObjectModel.object];
            refObj = ReferenceObjectModel.setPropView(
                objsRef.firstWhere(
                  (x) => x.referenceObject.id == idObjRef,
                  orElse: () => ReferenceObjectModel.empty(),
                ),
                objMap[prop.key][ReferenceObjectModel.property]);
            objMap[prop.key][ReferenceObjectModel.refObj] = refObj;
            objDB[_object] = objMap;
          }
        }

        obj = ObjectModel(
          id: objDB[id],
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

  /// Actualiza un objeto de la base de datos.
  static Future<void> update(ObjectModel object, WidgetLinkModel link) async {
    await _supabase
        .from(link.entity.tableName)
        .update({_object: object.map}).eq(id, object.id);
  }

  /// Elimina un objeto de la base de datos.
  static Future<void> delete(ObjectModel object, WidgetLinkModel link) async {
    await _supabase.from(link.entity.tableName).delete().eq(id, object.id);
  }

  /// Inserta un objeto en la base de datos.
  static Future<void> insert(ObjectModel object, WidgetLinkModel link) async {
    await _supabase.from(link.entity.tableName).insert({
      id: object.id,
      _object: object.map,
      _createAt: object.createAt.toIso8601String(),
    });
  }
}
