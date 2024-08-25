import 'package:flutter/material.dart';

import '../../modules/axol_widget/generic/view/axol_widget.dart';
import '../../modules/entity/model/property_model.dart';
import '../../modules/object/model/object_model.dart';
import '../format.dart';
import '../theme/theme.dart';

class ObjectCard extends AxolWidget {
  final ObjectModel object;
  final List<PropertyModel> propertyList;
  const ObjectCard({
    super.key,
    super.theme,
    required this.object,
    required this.propertyList,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final int theme_ = theme ?? 0;
    List<Widget> widgetList = [];

    for (String key in object.map.keys) {
      final value = object.map[key];
      final PropertyModel prop = propertyList.firstWhere((x) => x.key == key,
          orElse: () => PropertyModel.empty());
      if (prop.key != '' && prop.propertyType == Prop.text && value is String) {
        widgetList.add(Row(
          children: [
            Text(
              '${prop.name}:',
              style: Typo.subtitle(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (prop.key != '' &&
          (prop.propertyType == Prop.int || prop.propertyType == Prop.double) &&
          (value is int || value is double)) {
        widgetList.add(Row(
          children: [
            Text(
              '${prop.name}:',
              style: Typo.subtitle(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (prop.key != '' &&
          prop.propertyType == Prop.bool &&
          value is bool) {
        widgetList.add(Row(
          children: [
            Text(
              '${prop.name}:',
              style: Typo.subtitle(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (prop.key != '' &&
          prop.propertyType == Prop.time &&
          value is int) {
        widgetList.add(Row(
          children: [
            Text(
              '${prop.name}:',
              style: Typo.subtitle(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(value)),
              style: Typo.body(theme_),
            ),
          ],
        ));
      }
    }

    return Card(
      color: ColorTheme.background(theme_),
      shape: ContinuousRectangleBorder(
        side: BorderSide(
          color: ColorTheme.item30(theme_),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RawScrollbar(
          controller: scrollController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetList,
              ),
            ),
          )),
    );
  }
}
