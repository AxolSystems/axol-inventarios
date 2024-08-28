class ArrayModel {
  final String id;
  final List<String> list;
  final String value;

  ArrayModel({required this.id, required this.list, required this.value});

  ArrayModel.empty()
      : id = '',
        list = [],
        value = '';

  ArrayModel setValue(String value_) =>
      ArrayModel(id: id, list: list, value: value_);
}
