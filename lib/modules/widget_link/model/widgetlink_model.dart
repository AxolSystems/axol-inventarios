import '../../entity/model/entity_model.dart';
import 'widget_view_model.dart';

/// Enlace que sirve como puente entre bloque, módulo y
/// widget. El widgetLink se almacena en el módulo, toma
/// los datos del bloque al que está relacionado, y los
/// muestra filtrados, según la view seleccionada, en el
/// widget con el que se encuentra enlazado.
class WidgetLinkModel {
  final String id;
  final EntityModel entity;
  final int widget;
  final List<WidgetViewModel> views;

  WidgetLinkModel({
    required this.id,
    required this.entity,
    required this.widget,
    required this.views,
  });

  /// Devuelve el estado inicial del WidgetLinkModel.
  WidgetLinkModel.empty()
      : id = '',
        entity = EntityModel.empty(),
        widget = -1,
        views = [];

  static Map<String, dynamic> listToMap(List<WidgetLinkModel> list) {
    Map<String, dynamic> map = {};

    for (int i = 0; i < list.length; i++) {
      map[i.toString()] = list[i].id;
    }

    return map;
  }
}
