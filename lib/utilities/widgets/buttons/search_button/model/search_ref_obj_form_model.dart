import 'package:flutter/material.dart';

import '../../../../../modules/object/model/object_model.dart';
import '../../../../../modules/widget_link/model/widgetlink_model.dart';

class SearchRefObjFormModel {
  TextEditingController finderController;
  List<ObjectModel> objectList;
  WidgetLinkModel link;
  int currentPage;
  int totalPage;
  int limitRows;
  int totalReg;

  SearchRefObjFormModel({
    required this.finderController,
    required this.objectList,
    required this.link,
    required this.currentPage,
    required this.totalPage,
    required this.limitRows,
    required this.totalReg,
  });

  SearchRefObjFormModel.empty()
      : finderController = TextEditingController(),
        objectList = [],
        link = WidgetLinkModel.empty(),
        currentPage = 1,
        totalPage = 0,
        limitRows = 50,
        totalReg = 0;
}
