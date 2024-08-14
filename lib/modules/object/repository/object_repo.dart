import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../entity/model/entity_model.dart';
import '../../entity/model/property_model.dart';
import '../../widget_link/repository/widgetlink_repo.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';
import '../model/object_relation.dart';

class ObjectRepo {
  static const String id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static const String _references = 'references';
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
    List<FilterObjModel> upFilters = [];
    List<Map<String, dynamic>> objsDB;
    List<ObjectModel> objList = [];
    ObjectModel obj;
    String textOr = '';
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    final bool ascending_ = ascending ?? false;
    final String keyAscending_;
    final DataResponseModel dataResponse;
    Map<String, List<Map<String, dynamic>>> responseRef = {};
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponseRef;
    List<WidgetLinkModel> linkRefList = [];
    List<PropertyModel> propsRef = [];
    List<String> idLinks = [];
    List<PropertyModel> idRefProps = [];
    Map<String, List<FilterObjModel>> refFilters = {};
    List<FilterObjModel> refFilterList;

    /// Si no está ordenado por una propiedad, ordenar po fecha de
    /// creación.
    if (keyAscending == null) {
      keyAscending_ = _createAt;
    } else {
      keyAscending_ = '$_object->"$keyAscending"';
    }

    /// Si se escribió algo en el buscador, lo anexa a [textOr].
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

    /// Consulta objetos referenciados cuando hay un filtro activo.
    // 1. Enlista links de referencia y propiedades de entidad hijo que son referenciadas.
    idLinks = [];
    for (PropertyModel prop in link.entity.propertyList) {
      if (prop.dynamicValues.containsKey(PropertyModel.dvRefLink)) {
        if (idRefProps.indexWhere(
                (x) => x.dynamicValues.containsKey(PropertyModel.dvRefLink)) >
            -1) {
          idRefProps.add(prop);
        }
        if (!idLinks.contains(prop.dynamicValues[PropertyModel.dvRefLink])) {
          idLinks.add(prop.dynamicValues[PropertyModel.dvRefLink]);
        }
      }
    }
    linkRefList = await WidgetLinkRepo.fetchWidgetLik(idLinks);

    // 2. Enlista filtros de referencia y los mapea para filtros que son de la misma propiedad.
    for (PropertyModel prop in idRefProps) {
      refFilterList = [];
      for (FilterObjModel filter in filters) {
        if (filter.property.propertyType == Prop.referenceObject &&
            filter.property.key == prop.key) {
          refFilterList.add(filter);
        }
      }
      if (refFilterList.isNotEmpty) {
        refFilters[prop.key] = refFilterList;
      }
    }

    //3. Realiza la consulta en tabla padre.
    for (String key in refFilters.keys) {
      final WidgetLinkModel refLink =
          linkRefList.firstWhere((x) => x.id == key);
      var queryRef = _supabase
          .from(refLink.entity.tableName)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '$id,$_object->>${refFilters[key]!.first.property.key}',
              const FetchOptions(count: CountOption.estimated));
      for (FilterObjModel filter in refFilters[key]!) {
        queryRef = filterQuery(filter, queryRef);
      }
      postgrestResponseRef = await queryRef.range(from, to);
    }

    // <--

    /// Inicializa la estancia de la consulta indicando la tabla donde se
    /// realizará.
    var query = _supabase
        .from(link.entity.tableName)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.estimated));

    /// Agrega a la consulta el contenido de la barra de búsqueda con [textOr].
    if (search != null) {
      query = query.or(textOr);
    }

    /// Agrega los filtros a la consulta.
    for (FilterObjModel filter in filters) {
      query = filterQuery(filter, query);
    }

    /// Realiza la consulta de objetos.
    postgrestResponse = await query
        .range(rangeMin_, rangeMax_)
        .order(keyAscending_, ascending: ascending_);

    objsDB = postgrestResponse.data ?? [];

    /// Si la consulta de objetos dio algún resultado...
    if (objsDB.isNotEmpty) {
      List<String> idObjects = [];
      //List<String> idLinks = [];
      List<ReferenceObjectModel> objsRef = [];

      /// Si ha alguna propiedad referenciada, enlista los id de links de referencia
      /// y id de objetos referenciados.
      for (var prop in link.entity.propertyList) {
        if (prop.propertyType == Prop.referenceObject) {
          // Modificar -->
          /*propsRef.add(prop);
          if (!idLinks.contains(prop.dynamicValues[PropertyModel.dvRefLink])) {
            idLinks.add(prop.dynamicValues[PropertyModel.dvRefLink]);
          }*/
          // <--
          for (var objDB in objsDB) {
            final String? idObject = objDB[_object][prop.key];
            if (idObject != null && idObject != '') {
              idObjects.add(idObject);
            }
          }
        }
      }

      /// Si hay links referenciados, realiza una consulta con la lista de id de links
      /// y de la lista de id de objetos, para obtener links y objetos referenciados.
      if (idLinks.isNotEmpty) {
        //linkRefList = await WidgetLinkRepo.fetchWidgetLik(idLinks); // Modificar
        for (WidgetLinkModel link in linkRefList) {
          final List<Map<String, dynamic>> objRefDb = await _supabase
              .from(link.entity.tableName)
              .select<List<Map<String, dynamic>>>()
              .in_(id, idObjects);
          for (Map<String, dynamic> element in objRefDb) {
            objsRef.add(ReferenceObjectModel(
              referenceLink: link,
              referenceObject: ObjectModel(
                  createAt: DateTime.parse(element[_createAt]),
                  id: element[id],
                  map: element[_object]),
              idPropertyView: '',
            ));
          }
        }
      }

      /// Por cada objeto consultado que sea un objeto relacional,
      /// agrega el objeto referenciado a la propiedad que le
      /// pertenece.
      for (Map<String, dynamic> objDB in objsDB) {
        final Map<String, dynamic> objMap = objDB[_object];
        for (PropertyModel prop in propsRef) {
          final ReferenceObjectModel refObj;
          final String idObjRef;
          if (objMap.containsKey(prop.key)) {
            idObjRef = objMap[prop.key];
            refObj = ReferenceObjectModel.setPropView(
                objsRef.firstWhere(
                  (x) => x.referenceObject.id == idObjRef,
                  orElse: () => ReferenceObjectModel.empty(),
                ),
                link.entity.propertyList
                        .firstWhere(
                          (x) => x.key == prop.key,
                          orElse: () => PropertyModel.empty(),
                        )
                        .dynamicValues[ReferenceObjectModel.property] ??
                    '');
            objMap[prop.key] = refObj;
            objDB[_object] = objMap;
          }
        }

        /// Crea una lista de objetos a partir de las consultas realizadas.
        obj = ObjectModel(
          id: objDB[id],
          map: objDB[_object],
          createAt: DateTime.parse(objDB[_createAt]),
        );
        objList.add(obj);
      }
    }

    /// Agrega la lista de objetos resultado al modelo "DataResponse".
    dataResponse = DataResponseModel(
      dataList: objList,
      count: postgrestResponse.count ?? 0,
      dynamicValues: {ReferenceObjectModel.tRefLink: linkRefList},
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

  /// Inserta mediante una actualización un nuevo link a columna de referencias
  /// de la tabla en la base de datos. Primero realiza la consulta para obtener
  /// el jsonb de referencia y verificar si ya contiene el id del link a referenciar.
  /// En caso de que ya existe, se salta la actualización.
  static Future<void> insertReference(String idLink,
      WidgetLinkModel referenceLink, List<ObjectRelation> idObjList) async {
    Map<String, dynamic> referencesMap = {};
    List<Map<String, dynamic>> upsertList = [];
    bool existChild = false;
    String? removeKey;
    final List<Map<String, dynamic>> objRefDb = await _supabase
        .from(referenceLink.entity.tableName)
        .select<List<Map<String, dynamic>>>('$id,$_references')
        .in_(id, ObjectRelation.listParent(idObjList));

    for (ObjectRelation idObject in idObjList) {
      final Map<String, dynamic> row =
          objRefDb.firstWhere((x) => x[id] == idObject.newIdParentObject);
      final int iUpsert =
          upsertList.indexWhere((x) => x[id] == idObject.newIdParentObject);
      if (iUpsert > -1) {
        referencesMap = upsertList.elementAt(iUpsert)[_references];
      } else {
        referencesMap = row[_references] ?? {};
      }
      //Verifica si existe el id hijo.
      existChild = false;
      for (String key in referencesMap.keys) {
        if (referencesMap[key][ReferenceObjectModel.tRefLink] == idLink &&
            referencesMap[key][ReferenceObjectModel.object] ==
                idObject.idChildObject) {
          existChild = true;
        }
      }
      //Si no existe el id hijo en la fila, inserta las id.
      if (!existChild) {
        for (int i2 = 0; i2 <= referencesMap.keys.length; i2++) {
          if (!referencesMap.containsKey(i2.toString())) {
            referencesMap[i2.toString()] = {
              ReferenceObjectModel.tRefLink: idLink,
              ReferenceObjectModel.object: idObject.idChildObject
            };
            i2++;
          }
        }
        if (iUpsert > -1) {
          upsertList[iUpsert] = {
            id: idObject.newIdParentObject,
            _references: referencesMap
          };
        } else {
          upsertList.add(
              {id: idObject.newIdParentObject, _references: referencesMap});
        }
      }
    }

    // Actualiza eliminando los ObjectRelation de los oldIdParentObject.
    for (ObjectRelation idObject in idObjList) {
      final Map<String, dynamic> row =
          objRefDb.firstWhere((x) => x[id] == idObject.oldIdParentObject);
      final int iUpsert =
          upsertList.indexWhere((x) => x[id] == idObject.oldIdParentObject);
      if (iUpsert > -1) {
        referencesMap = upsertList.elementAt(iUpsert)[_references];
      } else {
        referencesMap = row[_references] ?? {};
      }

      if (referencesMap.isNotEmpty) {
        //Verifica si existe el id hijo.
        existChild = false;
        removeKey = null;
        for (String key in referencesMap.keys) {
          if (referencesMap[key][ReferenceObjectModel.tRefLink] == idLink &&
              referencesMap[key][ReferenceObjectModel.object] ==
                  idObject.idChildObject) {
            removeKey = key;
          }
        }
        if (removeKey != null) {
          referencesMap.remove(removeKey);
        }

        if (iUpsert > -1) {
          upsertList[iUpsert] = {
            id: idObject.oldIdParentObject,
            _references: referencesMap
          };
        } else {
          upsertList.add(
              {id: idObject.oldIdParentObject, _references: referencesMap});
        }
      }
    }

    if (upsertList.isNotEmpty) {
      await _supabase.from(referenceLink.entity.tableName).upsert(upsertList);
    }
  }

  static dynamic filterQuery(FilterObjModel filter, var query) {
    dynamic queryFlt = query;
    if (filter.operator == FilterOperator.eq) {
      queryFlt =
          queryFlt.eq('$_object->>"${filter.property.key}"', filter.value);
    }
    if (filter.operator == FilterOperator.like) {
      queryFlt = queryFlt.like(
          '$_object->>"${filter.property.key}"', '%${filter.value}%');
    }
    if (filter.operator == FilterOperator.ilike) {
      queryFlt = queryFlt.ilike(
          '$_object->>"${filter.property.key}"', '%${filter.value}%');
    }
    if (filter.operator == FilterOperator.gt) {
      queryFlt =
          queryFlt.gt('$_object->>"${filter.property.key}"', filter.value);
    }
    if (filter.operator == FilterOperator.gte) {
      queryFlt =
          queryFlt.gte('$_object->>"${filter.property.key}"', filter.value);
    }
    if (filter.operator == FilterOperator.lt) {
      queryFlt =
          queryFlt.lt('$_object->>"${filter.property.key}"', filter.value);
    }
    if (filter.operator == FilterOperator.lte) {
      queryFlt =
          queryFlt.lte('$_object->>"${filter.property.key}"', filter.value);
    }
    if (filter.operator == FilterOperator.neq) {
      queryFlt =
          queryFlt.neq('$_object->>"${filter.property.key}"', filter.value);
    }
    return queryFlt;
  }
}
