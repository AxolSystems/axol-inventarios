import 'package:flutter/widgets.dart';

import 'widgetlink_model.dart';

/// Modelo con datos mutables de drawer para buscar widgetLinks.
class WLinkDrawerFormModel {
  TextEditingController ctrlFind;
  List<WidgetLinkModel> links;
  List<WidgetLinkModel> filterLinks;

  WLinkDrawerFormModel({required this.ctrlFind, required this.links, required this.filterLinks});

  /// Estado inicial del modelo de datos.
  WLinkDrawerFormModel.empty()
      : ctrlFind = TextEditingController(),
        links = [],
        filterLinks = [];
}
