class QueryBuilder {
  String? query;
  String? table;
  String? oper;
  String? whereClause;
  String? urlGet;
  List filterParams = [];
  Map<String,dynamic> whereData = {};

  ///FROM, INTO
  QueryBuilder from(String tableName) {
    table ??= tableName;
    return this;
  }

  ///SELECT
  QueryBuilder select([String? columns]) {
    oper ??= 'SELECT ${columns ?? '*'}';
    return this;
  }

  ///INSERT
  QueryBuilder insert(Map<String, String> row) {
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
  }

  // *************** WHERE CLAUSE *************** //

  ///Equal
  QueryBuilder eq(String column, dynamic value) {
    if (value is String) {
      value = '\'$value\'';
    } else 
    if (whereClause == null) {
      //whereData[column] = value;
      filterParams.add(value);
      whereClause = 'WHERE $column = \$${filterParams.length}';
    } else {
      //whereData[column] = value;
      filterParams.add(value);
      whereClause = '$whereClause AND $column = \$${filterParams.length}';
    }
    return this;
  }

  String get getQuery {
    if (oper?.contains('SELECT') ?? false) {
      query = '$oper FROM $table ${whereClause ?? ''}';
    }

    return query ?? '';
  }

  String get getUrl {
    urlGet ??= '';
    for (var element in filterParams) {
      urlGet = '$urlGet/:$element';
    }
    return urlGet ?? '';
  }
}
