import '../../object/model/filter_obj_model.dart';

class EntryMenuModel {
  String text;
  List<FilterObjModel> filterList;

  EntryMenuModel({required this.text, required this.filterList});

  static EntryMenuModel empty() {
    return EntryMenuModel(
      text: '',
      filterList: [],
    );
  }
}
