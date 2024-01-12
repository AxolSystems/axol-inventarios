class DataFind {
  final int id;
  final String description;

  DataFind({required this.id, required this.description});

  DataFind.empty()
      : id = -1,
        description = '';
}
