class QueryBuilder {
  String? query;
  String? table;
  String? oper;
  String? whereClause;

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
    String valueText = '';
    if (value is String) {
      valueText = '\'$value\'';
    } else if (value is double || value is int) {
      valueText = value;
    }
    if (whereClause == null) {
      whereClause = 'WHERE $column = $valueText';
    } else {
      whereClause = '$whereClause AND $column = $valueText';
    }
    return this;
  }

  String get execute {
    if (oper?.contains('SELECT') ?? false) {
      query = '$oper FROM $table $whereClause';
    }

    return query ?? '';
  }
}
