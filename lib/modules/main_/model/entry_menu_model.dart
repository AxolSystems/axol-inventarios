class EntryMenuModel {
  int value;
  String text;
  Function() onPressed;

  EntryMenuModel(
      {required this.text, required this.value, required this.onPressed});

  static EntryMenuModel empty() {
    return EntryMenuModel(
      text: '',
      value: -1,
      onPressed: () {},
    );
  }
}
