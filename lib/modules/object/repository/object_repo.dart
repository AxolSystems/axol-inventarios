import 'package:axol_inventarios/modules/array/model/array_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data_response_model.dart';
import '../../../utilities/postgresql/query_builder.dart';
import '../../array/repository/array_repo.dart';
import '../../entity/model/entity_model.dart';
import '../../entity/model/property_model.dart';
import '../../widget_link/repository/widgetlink_repo.dart';
import '../model/atomic_object_model.dart';
import '../model/filter_obj_model.dart';
import '../model/object_model.dart';

class ObjectRepo {
  static const String id = 'id';
  static const String _object = 'object';
  static const String _createAt = 'create_at';
  static final _supabase = Supabase.instance.client;

  /*static Future<void> postgresFetch() async {
    //final QueryBuilder query = QueryBuilder().select('*').eq('id', 1);
    //final String urlGet = query.getUrl;

    final response = await http.get(
      Uri.parse('http://192.168.1.74:3000/api/element/1'),
      //body: jsonEncode(<String,String>{'query': query.getQuery})
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      /*final List<Product> productList = data
            .map((item) => Product(
                id: item['id'],
                code: item['code'],
                description: item['description'],
                price: (item['price'] as num).toDouble(),
                quantity: item['quantity']))
            .toList();
        state = AsyncValue.data(productList);*/
    } else {
      throw Exception('Error load element');
    }
  }

  static Future<void> postgresCreate() async {
    final QueryBuilder query = QueryBuilder().select('*').from('table0');
    final response = await http.post(
      Uri.parse(_uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query.getQuery, 'data': query.filterParams}),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
    } else {
      throw Exception('Error add new element');
    }
  }*/

  /*static Future<DataResponseModel> postgresFetchObject() async {
    final QueryBuilder query = QueryBuilder().select('*').from('table0');
    final DataResponseModel dataResponse;
    final response = await http.post(
      Uri.parse(_uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query.getQuery, 'data': query.filterParams}),
    );
    final responseCount = await http.post(
      Uri.parse(_uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': 'SELECT COUNT(*) FROM table0', 'data': []}),
    );

    if (response.statusCode == 200) {
      final dataList = json.decode(response.body);
      final int count = int.parse(json.decode(responseCount.body)[0]['count']);
      dataResponse = DataResponseModel(dataList: dataList, count: count);
      return dataResponse;
    } else {
      throw Exception('Error add new element');
    }
  }*/

  static Future<DataResponseModel> postgresFetchObject({
    required EntityModel entity,
    String? search,
  }) async {
    final DataResponseModel dataResponse;
    final List<Map<String, dynamic>> objectsDB;
    final List<ObjectModel> objectList = [];
    List<ArrayModel> arrayList = [];
    final List<String> idArrayList = [];
    Map<String, dynamic> map = {};
    final int count;
    //final String query = 'SELECT * FROM ${entity.tableName}';
    QueryBuilder query = QueryBuilder().select().from(entity.tableName);

    //1. Agrega filtros a query.
    if (search != null) {
      for (PropertyModel prop in entity.propertyList) {
        query.ilike(prop.key, search, oper: OperQuery.or);
      }
    }

    //2. Obtiene Map con módulos, widgets y vistas.
    //queryBuilder.query = query;
    objectsDB = await query.responseQuery; //queryBuilder.responseQuery;
    count = await query.countData(entity.tableName);

    //3. Obtiene arrays en caso de que haya propiedades de tipo array.
    if (entity.propertyList.indexWhere((x) => x.propertyType == Prop.array) >
        -1) {
      for (PropertyModel element
          in entity.propertyList.where((x) => x.propertyType == Prop.array)) {
        idArrayList.add(element.dynamicValues[PropertyModel.dvIdArray]);
      }
      arrayList = await ArrayRepo.postgresFetchArray(idArrayList);
    }

    //4. Convierte respuesta de base de datos a lista de modelo de objetos.
    for (Map<String, dynamic> element in objectsDB) {
      map = {};
      for (String key in element.keys) {
        if (key != 'id' && key != 'create_at') {
          final PropertyModel prop =
              entity.propertyList.firstWhere((x) => x.key == key);
          if (prop.propertyType == Prop.time) {
            map[key] = DateTime.parse(element[key]).millisecondsSinceEpoch;
          } else if (prop.propertyType == Prop.array) {
            final ArrayModel arrayDB = arrayList.firstWhere(
                (x) => x.id == prop.dynamicValues[PropertyModel.dvIdArray]);
            map[key] = ArrayModel(
              id: arrayDB.id,
              list: arrayDB.list,
              value: element[key] ?? '',
            );
          } else {
            map[key] = element[key];
          }
        }
      }
      objectList.add(ObjectModel(
        id: element['id'],
        map: map,
        createAt: DateTime.parse(element['create_at']),
      ));
    }

    dataResponse = DataResponseModel(dataList: objectList, count: count);

    return dataResponse;
  }

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
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponseRef;
    List<WidgetLinkModel> linkRefList = [];
    List<PropertyModel> propsRef = [];
    List<String> idLinks = [];
    List<PropertyModel> idRefProps = [];
    Map<String, List<FilterObjModel>> refFilters = {};
    List<String> idRefLinks = [];
    List<FilterObjModel> refFilterList;
    List<String> idAtomicListProps = [];
    List<String> idAtomicProps = [];
    List<PropertyModel> arrayProps = [];
    List<String> idArrays = [];
    List<ArrayModel> arrayList = [];

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
                (x) => x.dynamicValues.containsKey(PropertyModel.dvRefLink)) ==
            -1) {
          idRefProps.add(prop);
        }
        propsRef.add(prop);
        if (!idLinks.contains(prop.dynamicValues[PropertyModel.dvRefLink])) {
          idLinks.add(prop.dynamicValues[PropertyModel.dvRefLink]);
        }
      }
      if (prop.propertyType == Prop.atomicObjList) {
        idAtomicListProps.add(prop.key);
      }
      if (prop.propertyType == Prop.atomicObject) {
        idAtomicProps.add(prop.key);
      }
      if (prop.propertyType == Prop.array) {
        arrayProps.add(prop);
        idArrays.add(prop.dynamicValues[PropertyModel.dvIdArray]);
      }
    }
    linkRefList = await WidgetLinkRepo.fetchWidgetLik(idLinks);
    if (idArrays.isNotEmpty) {
      arrayList = await ArrayRepo.fetchArray(idArrays);
    }

    // 2. Enlista filtros de referencia y los mapea para filtros que son de la misma propiedad.
    for (PropertyModel prop in idRefProps) {
      refFilterList = [];
      for (FilterObjModel filter in filters) {
        if (filter.property.propertyType == Prop.referenceObject &&
            filter.property.key == prop.key) {
          final PropertyModel propertyRef = linkRefList
              .firstWhere(
                  (x) => x.id == prop.dynamicValues[PropertyModel.dvRefLink])
              .entity
              .propertyList
              .firstWhere((y) =>
                  y.key == prop.dynamicValues[ReferenceObjectModel.property]);
          refFilterList.add(filter.setProperty(propertyRef));
        }
      }
      if (refFilterList.isNotEmpty) {
        refFilters[prop.key] = refFilterList;
      }
    }

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
      if (filter.property.propertyType != Prop.referenceObject &&
          filter.property.propertyType != Prop.atomicObject) {
        query = filterQuery(filter, query);
      } else if (filter.property.propertyType == Prop.atomicObject) {
        for (FilterObjModel fltAtm
            in FilterObjModel.filterToObjFilter(filter.value)) {
          query = filterQueryAtm(filter, fltAtm, query);
        }
      }
    }

    /// Si hay filtros de referenciados, consulta las tablas padre y obtiene
    /// las id a mostrar que estén relacionados en la tabla hijo.
    if (refFilters.isNotEmpty) {
      for (String key in refFilters.keys) {
        final WidgetLinkModel refLink = linkRefList.firstWhere((x) =>
            x.id ==
            link.entity.propertyList
                .firstWhere((y) => y.key == key)
                .dynamicValues[PropertyModel.dvRefLink]);
        var queryRef = _supabase
            .from(refLink.entity.tableName)
            .select<PostgrestResponse<List<Map<String, dynamic>>>>(
                id, const FetchOptions(count: CountOption.estimated));

        for (FilterObjModel filter in refFilters[key]!) {
          queryRef = filterQuery(
              FilterObjModel(
                  property: filter.propertyRef!,
                  value: filter.value,
                  operator: filter.operator),
              queryRef);
        }

        /// TODO: Cambiar para que revise la tabla padre de mil en mil, en caso de
        /// que tenga más filas.
        postgrestResponseRef = await queryRef.range(0, 999);
        idRefLinks = [];
        for (var element in postgrestResponseRef.data ?? []) {
          if (element != null) {
            idRefLinks.add(element[id]);
          }
        }
        query = query.in_(
            '$_object->>"${refFilters[key]!.first.property.key}"', idRefLinks);
      }
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
                  orElse: () => ReferenceObjectModel(
                    idPropertyView:
                        prop.dynamicValues[ReferenceObjectModel.property],
                    referenceLink: linkRefList.firstWhere(
                      (x) =>
                          x.id == prop.dynamicValues[PropertyModel.dvRefLink],
                    ),
                    referenceObject: ObjectModel.empty(),
                  ),
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

        if (idAtomicListProps.isNotEmpty) {
          for (String idProp in idAtomicListProps) {
            if (objMap.containsKey(idProp)) {
              objMap[idProp] =
                  []; //Modificar para usar con listas de objetos atómicos.
            }
          }
          objDB[_object] = objMap;
        }

        if (idAtomicProps.isNotEmpty) {
          for (String idProp in idAtomicProps) {
            if (objMap.containsKey(idProp)) {
              objMap[idProp] = AtomicObjectModel.mapToAtomObj(objMap[idProp]);
            }
          }
          objDB[_object] = objMap;
        }

        if (arrayProps.isNotEmpty) {
          for (PropertyModel arrayProp in arrayProps) {
            if (objMap.containsKey(arrayProp.key)) {
              final String value = objMap[arrayProp.key];
              final ArrayModel array = arrayList
                  .firstWhere((x) =>
                      x.id == arrayProp.dynamicValues[PropertyModel.dvIdArray])
                  .setValue(value);
              objMap[arrayProp.key] = array;
            }
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

  /// Obtiene valores a sumar.
  static Future<double> querySum(WidgetLinkModel link, List<String> returnProps,
      List<String> fetchProps) async {
    List<Map<String, dynamic>> response;
    double total = 0;

    var query = _supabase
        .from(link.entity.tableName)
        .select<List<Map<String, dynamic>>>();

    for (String element in fetchProps) {
      query = query.eq('$_object->>"${element.split('==').first}"',
          element.split('==').last);
      //eq(element.split('==').first, element.split('==').last);
    }

    response = await query;
    for (String idProp in returnProps) {
      for (var element in response) {
        total =
            total + (double.tryParse(element[_object][idProp].toString()) ?? 0);
      }
    }

    return total;
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

  static dynamic filterQuery(FilterObjModel filter, var query) {
    dynamic queryFlt = query;
    dynamic value;

    if (filter.value is ArrayModel) {
      final ArrayModel array = filter.value;
      value = array.value;
    } else {
      value = filter.value;
    }

    if (filter.operator == FilterOperator.eq) {
      queryFlt = queryFlt.eq('$_object->>"${filter.property.key}"', value);
    }
    if (filter.operator == FilterOperator.like) {
      queryFlt =
          queryFlt.like('$_object->>"${filter.property.key}"', '%$value%');
    }
    if (filter.operator == FilterOperator.ilike) {
      queryFlt =
          queryFlt.ilike('$_object->>"${filter.property.key}"', '%$value%');
    }
    if (filter.operator == FilterOperator.gt) {
      queryFlt = queryFlt.gt('$_object->>"${filter.property.key}"', value);
    }
    if (filter.operator == FilterOperator.gte) {
      queryFlt = queryFlt.gte('$_object->>"${filter.property.key}"', value);
    }
    if (filter.operator == FilterOperator.lt) {
      queryFlt = queryFlt.lt('$_object->>"${filter.property.key}"', value);
    }
    if (filter.operator == FilterOperator.lte) {
      queryFlt = queryFlt.lte('$_object->>"${filter.property.key}"', value);
    }
    if (filter.operator == FilterOperator.neq) {
      queryFlt = queryFlt.neq('$_object->>"${filter.property.key}"', value);
    }
    return queryFlt;
  }

  static dynamic filterQueryAtm(
    FilterObjModel filter,
    FilterObjModel filterAtm,
    var query,
  ) {
    dynamic queryFlt = query;
    if (filterAtm.operator == FilterOperator.eq) {
      queryFlt = queryFlt.eq(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    if (filterAtm.operator == FilterOperator.like) {
      queryFlt = queryFlt.like(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          '%${filterAtm.value}%');
    }
    if (filterAtm.operator == FilterOperator.ilike) {
      queryFlt = queryFlt.ilike(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          '%${filterAtm.value}%');
    }
    if (filterAtm.operator == FilterOperator.gt) {
      queryFlt = queryFlt.gt(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    if (filterAtm.operator == FilterOperator.gte) {
      queryFlt = queryFlt.gte(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    if (filterAtm.operator == FilterOperator.lt) {
      queryFlt = queryFlt.lt(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    if (filterAtm.operator == FilterOperator.lte) {
      queryFlt = queryFlt.lte(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    if (filterAtm.operator == FilterOperator.neq) {
      queryFlt = queryFlt.neq(
          '$_object->"${filter.property.key}"->"${AtomicObjectModel.tObject}"->>"${filterAtm.property.key}"',
          filterAtm.value);
    }
    return queryFlt;
  }
}
