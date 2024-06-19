import 'package:axol_inventarios/modules/axol_widget/generic/model/data_object.dart';
import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';

import '../view/axol_widget.dart';
import '../../table/model/table_model.dart';
import '../../table/view/table_view.dart';

/// Clase con métodos para convertir los objetos en otros tipos de datos.
class WidgetIndex {
  static int get table => 0;

  /// Según el índice que se reciba, devuelve el widget equivalente.
  static AxolWidget widget(int i, DataObject data, int theme) {
    switch (i) {
      case 0:
        if (data is TableModel) {
          return TableView(table: data, themes: theme);
        } else {
          return TableView(
            table: TableModel.empty(),
            themes: theme,
          );
        }
      default:
        return const EmptyWidget();
    }
  }

  /// Según el índice recibido, devuelve el tipo de dato requerido.
  static DataObject data(int i, List<ObjectModel> objects, BlockModel block) {
    switch (i) {
      case 0:
        return TableModel.dataObject(objects, block);
      default:
        return DefaultData();
    }
  }
}
