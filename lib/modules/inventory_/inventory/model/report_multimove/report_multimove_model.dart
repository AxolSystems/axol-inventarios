import 'report_mutlimove_row_model.dart';

class ReportMultimoveModel {
  final DateTime startTime;
  final DateTime endTime;
  final String document;
  final List<ReportMultimoveRowModel> rowList;

  const ReportMultimoveModel({
    required this.document,
    required this.endTime,
    required this.rowList,
    required this.startTime,
  });

  ReportMultimoveModel.empty()
      : document = '',
        endTime = DateTime(0),
        startTime = DateTime(0),
        rowList = [];

  static ReportMultimoveModel addRow({
    required ReportMultimoveModel reportMultimove,
    required ReportMultimoveRowModel row,
  }) {
    ReportMultimoveModel upMultimove;
    List<ReportMultimoveRowModel> rowList;

    rowList = reportMultimove.rowList;
    rowList.add(row);

    upMultimove = ReportMultimoveModel(
      document: reportMultimove.document,
      endTime: reportMultimove.endTime,
      rowList: rowList,
      startTime: reportMultimove.startTime,
    );
    return upMultimove;
  }

  static ReportMultimoveModel changeStartTime({
    required ReportMultimoveModel reportMultimove,
    required DateTime startTime,
  }) {
    ReportMultimoveModel upMultimove;

    upMultimove = ReportMultimoveModel(
      document: reportMultimove.document,
      endTime: reportMultimove.endTime,
      rowList: reportMultimove.rowList,
      startTime: startTime,
    );
    return upMultimove;
  }

  static ReportMultimoveModel changeEndTime({
    required ReportMultimoveModel reportMultimove,
    required DateTime endTime,
  }) {
    ReportMultimoveModel upMultimove;

    upMultimove = ReportMultimoveModel(
      document: reportMultimove.document,
      endTime: endTime,
      rowList: reportMultimove.rowList,
      startTime: reportMultimove.startTime,
    );
    return upMultimove;
  }

  static ReportMultimoveModel changeDoc({
    required ReportMultimoveModel reportMultimove,
    required String document,
  }) {
    ReportMultimoveModel upMultimove;

    upMultimove = ReportMultimoveModel(
      document: document,
      endTime: reportMultimove.endTime,
      rowList: reportMultimove.rowList,
      startTime: reportMultimove.startTime,
    );
    return upMultimove;
  }
}
