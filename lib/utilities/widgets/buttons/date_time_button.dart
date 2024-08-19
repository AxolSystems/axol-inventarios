import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/axol_widget/generic/view/axol_widget.dart';
import '../../format.dart';
import '../../theme/theme.dart';

class DateTimeButton extends AxolWidget {
  final DateTime dateTime;
  final Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  const DateTimeButton({
    super.key,
    super.theme,
    required this.dateTime,
    this.onPressed,
    this.margin,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: OutlinedButton(
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
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormatDate.dmyHm(dateTime),
                  style: Typo.body(theme_),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.calendar_month,
                  color: ColorTheme.item10(theme_),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeDialog extends AxolWidget {
  final DateTime dateTime;
  const DateTimeDialog({
    super.key,
    super.theme,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DateTimeDialogCubit()),
        BlocProvider(create: (_) => DateTimeDialogForm(dateTime)),
      ],
      child: DateTimeDialogBuild(
        dateTime: dateTime,
        theme: theme,
      ),
    );
  }
}

class DateTimeDialogBuild extends AxolWidget {
  final DateTime dateTime;
  const DateTimeDialogBuild({
    super.key,
    super.theme,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    DateTime form = context.read<DateTimeDialogForm>().state;
    return BlocBuilder(
        bloc: context.read<DateTimeDialogCubit>()..initLoad(form, dateTime),
        builder: (context, state) {
          return AlertDialog(
            backgroundColor: ColorTheme.background(theme_),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    theme: theme,
                    text: 'Cancelar',
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    theme: theme_,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    text: 'Aceptar',
                    onPressed: () {
                      Navigator.pop(context, form);
                    },
                  ),
                ],
              )
            ],
            content: Row(
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    side: WidgetStatePropertyAll(
                        BorderSide(color: ColorTheme.item20(theme_))),
                    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
                    backgroundColor:
                        WidgetStatePropertyAll(ColorTheme.fill(theme_)),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                      initialDate: form,
                    ).then(
                      (value) {
                        if (value != null) {
                          form = DateTime(
                            value.year,
                            value.month,
                            value.day,
                            form.hour,
                            form.minute,
                          );
                          context.read<DateTimeDialogCubit>().load();
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          FormatDate.dmy(form),
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
                const SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    side: WidgetStatePropertyAll(
                        BorderSide(color: ColorTheme.item20(theme_))),
                    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
                    backgroundColor:
                        WidgetStatePropertyAll(ColorTheme.fill(theme_)),
                  ),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(form),
                    ).then(
                      (value) {
                        if (value != null) {
                          form = DateTime(
                            form.year,
                            form.month,
                            form.day,
                            value.hour,
                            value.minute,
                          );
                          context.read<DateTimeDialogCubit>().load();
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          FormatDate.hm(TimeOfDay.fromDateTime(form)),
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
        });
  }
}

enum DateTimeDialogState { init, loading, loaded, error }

class DateTimeDialogCubit extends Cubit<DateTimeDialogState> {
  DateTimeDialogCubit() : super(DateTimeDialogState.init);

  Future<void> load() async {
    try {
      emit(DateTimeDialogState.init);
      emit(DateTimeDialogState.loading);

      emit(DateTimeDialogState.loaded);
    } catch (e) {
      emit(DateTimeDialogState.init);
      // ignore: avoid_print
      print(e);
      emit(DateTimeDialogState.error);
    }
  }

  Future<void> initLoad(DateTime form, DateTime dateTime) async {
    try {
      emit(DateTimeDialogState.init);
      emit(DateTimeDialogState.loading);
      form = dateTime;
      emit(DateTimeDialogState.loaded);
    } catch (e) {
      emit(DateTimeDialogState.init);
      // ignore: avoid_print
      print(e);
      emit(DateTimeDialogState.error);
    }
  }
}

class DateTimeDialogForm extends Cubit<DateTime> {
  DateTimeDialogForm(DateTime dateTime) : super(dateTime);
}
