class TextfieldModel {
  final String text;
  final int position;

  const TextfieldModel({required this.text, required this.position});

  TextfieldModel.empty()
    : text = '',
      position = 0;
}
