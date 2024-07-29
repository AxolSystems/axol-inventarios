import 'package:flutter/material.dart';

import '../../modules/axol_widget/generic/view/axol_widget.dart';
import '../format.dart';
import '../theme/theme.dart';

class DateTimeButton extends AxolWidget {
  final DateTime dateTime;
  final Function()? onPressed;
  const DateTimeButton({
    super.key,
    super.theme,
    required this.dateTime,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return OutlinedButton(
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        side: WidgetStatePropertyAll(
            BorderSide(color: ColorTheme.item20(theme_))),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)))),
        backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme_)),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              FormatDate.dmy(dateTime),
              style: Typo.body(theme_),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_month,
              color: ColorTheme.item10(theme_),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimeDialog extends AxolWidget {
  final DateTime dateTime;
  const DateTimeDialog({super.key, super.theme, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return AlertDialog(
      content: Row(
        children: [
          OutlinedButton(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              side: WidgetStatePropertyAll(
                  BorderSide(color: ColorTheme.item20(theme_))),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme_)),
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    FormatDate.dmy(dateTime),
                    style: Typo.body(theme_),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_month,
                    color: ColorTheme.item10(theme_),
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              side: WidgetStatePropertyAll(
                  BorderSide(color: ColorTheme.item20(theme_))),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme_)),
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    FormatDate.hm(TimeOfDay.fromDateTime(dateTime)),
                    style: Typo.body(theme_),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.access_time,
                    color: ColorTheme.item10(theme_),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
