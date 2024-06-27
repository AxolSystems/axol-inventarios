import 'package:flutter/widgets.dart';

import 'widgetlink_model.dart';

class WLinkDrawerFormModel {
  TextEditingController ctrlFind;
  List<WidgetLinkModel> links;

  WLinkDrawerFormModel({required this.ctrlFind, required this.links});

  WLinkDrawerFormModel.empty()
      : ctrlFind = TextEditingController(),
        links = [];
}
