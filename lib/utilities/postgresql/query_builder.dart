import 'dart:convert';

import 'package:http/http.dart' as http;

import 'postgres_client.dart';

class QueryBuilder {
  String? query;

  ///FROM
  QueryBuilder from(String tableName) {
    if (query != null) {
      query = '$query FROM $tableName';
    }
    return this;
  }

  ///SELECT
  QueryBuilder select([String? columns]) {
    query ??= 'SELECT ${columns ?? '*'}';
    return this;
  }

  //INSERT
  /*QueryBuilder insert(Map<String, String> row) {
    String columns = '';
    String values = '';

    for (String key in row.keys) {
      if (columns == '') {
        columns = key;
      } else {
        columns = '$columns, $key';
      }
      if (values == '') {
        values = '\'${row[key]!}\'';
      } else {
        values = '$values, \'${row[key]}\'';
      }
    }

    oper ??= 'INSERT';
    if (table != null) {
      query ??= '$oper INTO $table ($columns) VALUES ($values)';
    }

    return this;
  }*/

  // *************** WHERE CLAUSE *************** //

  /// EQ
  ///
  /// Devuelve las filas donde en [column] sean igual a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .eq('country','Mexico');
  /// ```
  /// sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE country = 'Mexico';
  /// ```
  QueryBuilder eq(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().eq(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND ${filter.clause}';
      } else {
        query = '$query WHERE ${filter.clause}';
      }
    }
    return this;
  }

  /// NEQ
  ///
  /// Devuelve las filas donde en [column] los valores no sean igual a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .neq('country','Mexico');
  /// ```
  /// sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE country <> 'Mexico';
  /// ```
  QueryBuilder neq(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().eq(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND ${filter.clause}';
      } else {
        query = '$query WHERE ${filter.clause}';
      }
    }
    return this;
  }

  /// IN
  ///
  /// Devuelve las filas donde en [column] coincidan con
  /// los valores de [values].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .in_('country',['Mexico', 'Colombia', 'Argentina']);
  /// ```
  /// sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE country IN ('Mexico', 'Colombia', 'Argentina');
  /// ```
  QueryBuilder in_(String column, List values) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().in_(column, values);
      if (query!.contains('WHERE')) {
        query = '$query AND ${filter.clause}';
      } else {
        query = '$query WHERE ${filter.clause}';
      }
    }
    return this;
  }

  /// LIKE
  ///
  /// Devuelve las filas donde en [column] coincidan valores que
  /// contengan [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .like('country','Mex');
  /// ```
  /// sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE country LIKE '%Mex%' ;
  /// ```
  QueryBuilder like(String column, String value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().like(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  //ILIKE
  ///
  /// Devuelve las filas donde en [column] coincidan valores que
  /// contengan [value], sin importar si son mayúsculas o minúsculas.
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .ilike('country','Mex');
  /// ```
  /// sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE country ILIKE '%Mex%' ;
  /// ```
  QueryBuilder ilike(String column, String value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().ilike(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  /// GT
  ///
  /// Devuelva las filas donde en [column] los valores sean mayores a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .gt('year', 1900);
  /// ```
  /// Sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE year > 1900 ;
  /// ```
  QueryBuilder gt(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().gt(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  /// GTE
  ///
  /// Devuelva las filas donde en [column] los valores sean mayores o iguales a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .gte('year', 1900);
  /// ```
  /// Sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE year >= 1900 ;
  /// ```
  QueryBuilder gte(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().gte(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  /// LT
  ///
  /// Devuelva las filas donde en [column] los valores sean menores a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .lt('year', 1900);
  /// ```
  /// Sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE year < 1900 ;
  /// ```
  QueryBuilder lt(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().lt(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  /// LTE
  ///
  /// Devuelva las filas donde en [column] los valores sean menores o iguales a [value].
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .lte('year', 1900);
  /// ```
  /// Sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE year <= 1900 ;
  /// ```
  QueryBuilder lte(String column, dynamic value) {
    final FilterQuery filter;
    if (query != null) {
      filter = FilterQuery().lte(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
      }
    }
    return this;
  }

  /// OR
  ///
  /// Una agrupación de clausulas en las que devuelve todas las filas
  /// que coincida con cualquiera de ellas.
  ///
  /// ```dart
  /// BuilderQuery() query = BuilderQuery()
  ///   .select()
  ///   .from('countries')
  ///   .or([FilterQuery().eq('country','Mexico'), FilterQuery().like('country','Col')]);
  /// ```
  ///
  /// Sql:
  /// ```sql
  /// SELECT * FROM countries
  /// WHERE (country = 'Mexico' OR country LIKE '%Col%') ;
  /// ```
  QueryBuilder or(List<FilterQuery> filterList) {
    String filter = '';
    for (FilterQuery flt in filterList) {
      if (filter == '') {
        filter = flt.clause ?? '';
      } else {
        filter = '$filter OR ${flt.clause}';
      }
    }
    if (query!.contains('WHERE')) {
      query = '$query AND ($filter)';
    } else {
      query = '$query WHERE ($filter)';
    }

    return this;
  }

  // ****************** EXECUTE QUERY ****************** //
  /// Ejecuta la consulta en la base de datos y recibe su respuesta.
  ///
  /// ```dart
  /// BuildQuery query = BuildQuery().select().form('countries');
  /// final response = await query.responseQuery;
  /// ```
  Future<List<Map<String, dynamic>>> get responseQuery async {
    const String uri = PostgresClient.urlHttp;
    List<Map<String, dynamic>> response = [];

    final postgresResponse = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query, 'data': []}),
    );

    if (postgresResponse.statusCode == 200) {
      final responseDecode = json.decode(postgresResponse.body);
      for (var element in responseDecode) {
        response.add(element);
      }
    } else {
      throw Exception('Error query response');
    }

    return response;
  }

  /// Devuelve la cantidad de filas en una tabla.
  Future<int> countData(String tableName) async {
    const String uri = PostgresClient.urlHttp;
    final responseCount = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body:
          jsonEncode({'query': 'SELECT COUNT(*) FROM $tableName', 'data': []}),
    );
    if (responseCount.statusCode == 200) {
      final int count = int.parse(json.decode(responseCount.body)[0]['count']);
      return count;
    } else {
      throw Exception('Error query count');
    }
  }
}

class FilterQuery {
  String? clause;

  FilterQuery eq(String column, dynamic value) {
    if (value is String) {
      value = _valueText(value);
    }
    clause = '$column = $value';
    return this;
  }

  FilterQuery in_(String column, List values) {
    String inValues = '';
    for (var element in values) {
      if (element is String) {
        element = _valueText(element);
      }
      if (inValues == '') {
        inValues = '$element';
      } else {
        inValues = ',$element';
      }
    }
    clause = '$column IN ($inValues)';
    return this;
  }

  FilterQuery like(String column, String value) {
    clause = '$column LIKE \'%$value%\'';
    return this;
  }

  FilterQuery ilike(String column, String value) {
    clause = '$column ILIKE \'%$value%\'';
    return this;
  }

  FilterQuery gt(String column, dynamic value) {
    if (value is DateTime) {
      clause = '$column > ${_valueText(value.toIso8601String())}';
    } else if (value is int || value is double) {
      clause = '$column > $value';
    }
    return this;
  }

  FilterQuery gte(String column, dynamic value) {
    if (value is DateTime) {
      clause = '$column >= ${_valueText(value.toIso8601String())}';
    } else if (value is int || value is double) {
      clause = '$column >= $value';
    }
    return this;
  }

  FilterQuery lt(String column, dynamic value) {
    if (value is DateTime) {
      clause = '$column < ${_valueText(value.toIso8601String())}';
    } else if (value is int || value is double) {
      clause = '$column < $value';
    }
    return this;
  }

  FilterQuery lte(String column, dynamic value) {
    if (value is DateTime) {
      clause = '$column <= ${_valueText(value.toIso8601String())}';
    } else if (value is int || value is double) {
      clause = '$column <= $value';
    }
    return this;
  }

  FilterQuery neq(String column, dynamic value) {
    if (value is String) {
      value = _valueText(value);
    }
    clause = '$column <> $value';
    return this;
  }

  // **************** PRIVATE METHODS **************** //

  static String _valueText(dynamic value) => '\'$value\'';
}

enum OperQuery { and, or }
