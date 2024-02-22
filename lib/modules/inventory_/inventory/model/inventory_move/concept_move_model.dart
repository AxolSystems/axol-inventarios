class ConceptMoveModel {
  final int id;
  final int type;
  final String text;

  static String get sale => 'Venta';

  const ConceptMoveModel({
    required this.text,
    required this.id,
    required this.type,
  });

  ConceptMoveModel.empty() : 
        text = '',
        id = -1,
        type = -1;
}
