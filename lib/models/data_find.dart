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
