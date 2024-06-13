import '../../block/model/block_model.dart';
import 'widget_view_model.dart';

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
  WidgetLinkModel.empty()
      : id = '',
        block = BlockModel.empty(),
        widget = -1,
        views = [];
}
