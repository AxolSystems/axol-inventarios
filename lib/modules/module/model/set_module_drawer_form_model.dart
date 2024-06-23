import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widget_link/model/widgetlink_model.dart';

class SetModuleDrawerFormModel {
  TextEditingController ctrlName;
  TextEditingController ctrlIcon;
  List<WidgetLinkModel> links;

  SetModuleDrawerFormModel({
    required this.ctrlName,
    required this.ctrlIcon,
    required this.links,
  });

  SetModuleDrawerFormModel.empty()
      : ctrlName = TextEditingController(),
        ctrlIcon = TextEditingController(),
        links = [];
}
