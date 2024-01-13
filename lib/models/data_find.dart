class DataFind {
  final int id;
  final String description;
  final dynamic data;

  DataFind({required this.id, required this.description, this.data});

  DataFind.empty()
      : id = -1,
        description = '',
        data = null;
}
