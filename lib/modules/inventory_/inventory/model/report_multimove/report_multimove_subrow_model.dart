import '../inventory_move/concept_move_model.dart';

class ReportMultimoveSubrowModel {
  final DateTime dateTime;
  final String document;
  final int folio;
  final ConceptMoveModel concept;
  final double quantity;

  const ReportMultimoveSubrowModel({
    required this.concept,
    required this.dateTime,
    required this.document,
    required this.folio,
    required this.quantity,
  });

  ReportMultimoveSubrowModel.empty()
      : concept = ConceptMoveModel.empty(),
        dateTime = DateTime(0),
        document = '',
        folio = -1,
        quantity = 0;
}
