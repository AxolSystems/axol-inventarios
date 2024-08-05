import 'package:flutter/material.dart';

import '../../../object/model/object_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import 'filter_property_form_model.dart';

class SearchRefObjFormModel {
  TextEditingController finderController;
  List<ObjectModel> objectList;
  List<PropChecked> propCheckedList;
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
    required this.propCheckedList,
  });

  SearchRefObjFormModel.empty()
      : finderController = TextEditingController(),
        objectList = [],
        link = WidgetLinkModel.empty(),
        propCheckedList = [],
        currentPage = 1,
        totalPage = 0,
        limitRows = 50,
        totalReg = 0;
}
