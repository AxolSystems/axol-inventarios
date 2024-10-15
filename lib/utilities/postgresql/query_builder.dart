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

  /// EQUAL
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
    final String filter;
    if (query != null) {
      filter = FilterQuery.eq(column, value);
      if (query!.contains('WHERE')) {
        query = '$query AND $filter';
      } else {
        query = '$query WHERE $filter';
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
    if (query!.contains('WHERE')) {
      query = '$query AND $column IN ($inValues)';
    } else {
      query = '$query WHERE $column IN ($inValues)';
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
  QueryBuilder like(String column, String value, {OperQuery? oper}) {
    final String operText = _getOperText(oper);
    value = _valueTextLike(value);
    if (query!.contains('WHERE')) {
      query = '$query $operText $column LIKE $value';
    } else {
      query = '$query WHERE $column LIKE $value';
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
  QueryBuilder ilike(String column, String value, {OperQuery? oper}) {
    final String operText = _getOperText(oper);
    value = _valueTextLike(value);
    if (query!.contains('WHERE')) {
      query = '$query $operText $column ILIKE $value';
    } else {
      query = '$query WHERE $column ILIKE $value';
    }
    return this;
  }

  QueryBuilder or(List<FilterQuery> filterList) {
    for (FilterQuery flt in filterList) {
      if (y.elementAt(1) == 'eq') {
        filter = FilterQuery.eq(column, value);
        if (query!.contains('WHERE')) {
          query = '$query AND $filter';
        } else {
          query = '$query WHERE $filter';
        }
      }
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
      throw Exception('Error add new element');
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
      throw Exception('Error add new element');
    }
  }

  // **************** PRIVATE METHODS **************** //

  String _valueText(dynamic value) => '\'$value\'';
  String _valueTextLike(dynamic value) => '\'%$value%\'';
  String _getOperText(OperQuery? oper) {
    String operText = 'AND';
    if (oper != null || oper == OperQuery.and) {
      operText = 'AND';
    } else if (oper == OperQuery.or) {
      operText = 'OR';
    }
    return operText;
  } 
}

class FilterQuery {
  static String eq(String column, dynamic value) {
    if (value is String) {
      value = _valueText(value);
    }
    return '$column = $value';
  }

  static String _valueText(dynamic value) => '\'$value\'';
}

class FilterData {
  final String data;
  final 
}

enum OperQuery { and, or }
enum FilterType {eq}
