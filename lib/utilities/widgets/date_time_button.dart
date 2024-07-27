import 'package:flutter/material.dart';

import '../../modules/axol_widget/generic/view/axol_widget.dart';
import '../format.dart';
import '../theme/theme.dart';

class DateTimeButton extends AxolWidget {
  final DateTime dateTime;
  const DateTimeButton({
    super.key,
    super.theme,
    required this.dateTime,
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
      onPressed: () {
        /*showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then(
                (value) {
                  context.read<FilterCubit>().thenDateTimePick(
                        form: form,
                        index: index,
                        date: value,
                      );
                },
              );*/
      },
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
  const DateTimeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return 
  }

}


