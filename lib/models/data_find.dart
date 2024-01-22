class DataFind {
  final String id;
  final String description;
  final dynamic data;

  DataFind({required this.id, required this.description, this.data});

  DataFind.empty()
      : id = '',
        description = '',
        data = null;
}

class DataFindValues {
  final List<String> values;
  final dynamic data;

  DataFindValues({required this.values, this.data});

  DataFindValues.empty()
      : values = [],
        data = null;
}
