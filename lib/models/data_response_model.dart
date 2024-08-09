class DataResponseModel {
  final List dataList;
  final int count;
  final Map<String,dynamic>? dynamicValues;

  DataResponseModel({
    required this.dataList,
    required this.count,
    this.dynamicValues,
  });
}
