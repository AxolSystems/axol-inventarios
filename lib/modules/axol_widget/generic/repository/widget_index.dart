import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:axol_inventarios/modules/axol_widget/generic/model/data_object.dart';

import '../../../entity/model/entity_model.dart';
import '../../../user/model/user_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../view/axol_widget.dart';
import '../../table/model/table_model.dart';
import '../../table/view/table_view.dart';

/// Clase con métodos para convertir los objetos en otros tipos de datos.
class WidgetIndex {
  static int get table => 0;

  /// Según el índice que se reciba, devuelve el widget equivalente.
  static AxolWidget widget(
    {
    required int i,
    required UserModel user,
    required WidgetLinkModel link,
    required String viewId,
    }
  ) {
    switch (i) {
      case 0:
        if (data is TableModel) {
          return TableView(
            //user: user,
            link: link,
            viewId: viewId,
          );
        } else {
          return TableView(
            //user: user,
            link: link,
            viewId: viewId,
          );
        }
      default:
        return const EmptyWidget();
    }
  }

  /// Según el índice recibido, devuelve el tipo de dato requerido.
  static DataObject data(int i, DataResponseModel dataResponse, EntityModel entity) {
    switch (i) {
      case 0:
        return TableModel.dataObject(dataResponse, entity);
      default:
        return DefaultData();
    }
  }
}
