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
    final int theme_ = theme ?? 0;
    List<Widget> widgetList = [];

    for (String key in object.map.keys) {
      final value = object.map[key];
      final PropertyModel propEntity = propertyList.firstWhere(
          (x) => x.key == prop.key,
          orElse: () => PropertyModel.empty());
      final PropertyModel propAtm = PropertyModel.mapToSingleProp(
          propEntity.dynamicValues[PropertyModel.dvPropsAtomObj][key], key);
      if (propAtm.key != '' &&
          propAtm.propertyType == Prop.text &&
          value is String) {
        widgetList.add(Row(
          children: [
            Text(
              propAtm.name,
              style: Typo.body(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (propAtm.key != '' &&
          (propAtm.propertyType == Prop.int ||
              propAtm.propertyType == Prop.double) &&
          (value is int || value is double)) {
        widgetList.add(Row(
          children: [
            Text(
              propAtm.name,
              style: Typo.body(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (propAtm.key != '' &&
          propAtm.propertyType == Prop.bool &&
          value is bool) {
        widgetList.add(Row(
          children: [
            Text(
              propAtm.name,
              style: Typo.body(theme_),
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: Typo.body(theme_),
            ),
          ],
        ));
      } else if (propAtm.key != '' &&
          propAtm.propertyType == Prop.time &&
          value is int) {
        widgetList.add(Row(
          children: [
            Text(
              propAtm.name,
              style: Typo.body(theme_),
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

    return Card();
  }
}
