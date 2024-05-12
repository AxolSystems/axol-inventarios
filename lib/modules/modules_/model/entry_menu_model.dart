class EntryMenuModel {
  int value;
  String text;

  EntryMenuModel({required this.text, required this.value});

  EntryMenuModel.empty()
      : text = '',
        value = -1;
}
