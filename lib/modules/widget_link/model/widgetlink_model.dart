import '../../block/model/block_model.dart';
import 'widget_view_model.dart';

/// Enlace que sirve como puente entre bloque, módulo y 
/// widget. El widgetLink se almacena en el módulo, toma 
/// los datos del bloque al que está relacionado, y los 
/// muestra filtrados, según la view seleccionada, en el 
/// widget con el que se encuentra enlazado.
class WidgetLinkModel {
  final String id;
  final BlockModel block;
  final int widget;
  final List<WidgetViewModel> views;

  WidgetLinkModel({
    required this.id,
    required this.block,
    required this.widget,
    required this.views,
  });

  /// Devuelve el estado inicial del WidgetLinkModel.
  WidgetLinkModel.empty()
      : id = '',
        block = BlockModel.empty(),
        widget = -1,
        views = [];
}
