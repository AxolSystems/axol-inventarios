class ConceptMoveModel {
  final int id;
  final int type;
  final String text;

  static String get sale => 'Venta';
  static String get conceptName58 => 'Salida por traspaso';
  static String get conceptName7 => 'Entrada por traspaso';
  static String get conceptName4 => 'Cancelación de nota';

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
