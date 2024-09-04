import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/axol_widget/generic/view/axol_widget.dart';
import '../../format.dart';
import '../../theme/theme.dart';

class DateTimeButton extends AxolWidget {
  final DateTime? dateTime;
  final Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final bool? isFocus;
  const DateTimeButton({
    super.key,
    super.theme,
    required this.dateTime,
    this.onPressed,
    this.margin,
    this.width,
    this.padding,
    this.isFocus,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    final FocusNode focusNode = FocusNode();
    if (isFocus == true) {
      focusNode.requestFocus();
    } else {
      //focusNode.unfocus()
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: OutlinedButton(
          focusNode: focusNode,
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
                  dateTime == null
                      ? ''
                      : FormatDate.dmyHm(dateTime ?? DateTime.now()),
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
  final bool? isBlank;
  const DateTimeDialog({
    super.key,
    super.theme,
    required this.dateTime,
    this.isBlank,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DateTimeDialogCubit()),
        BlocProvider(
            create: (_) => DateTimeDialogForm(dateTime, isBlank ?? false)),
      ],
      child: DateTimeDialogBuild(
        dateTime: dateTime,
        theme: theme,
        isBlank: isBlank,
      ),
    );
  }
}

class DateTimeDialogBuild extends AxolWidget {
  final DateTime dateTime;
  final bool? isBlank;
  const DateTimeDialogBuild({
    super.key,
    super.theme,
    required this.dateTime,
    required this.isBlank,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    DateTimeDialogFormModel form = context.read<DateTimeDialogForm>().state;
    return BlocBuilder(
        bloc: context.read<DateTimeDialogCubit>()
          ..initLoad(form, dateTime, isBlank ?? false),
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            side: WidgetStatePropertyAll(
                                BorderSide(color: ColorTheme.item20(theme_))),
                            shape: const WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                            backgroundColor:
                                WidgetStatePropertyAll(ColorTheme.fill(theme_)),
                          ),
                          onPressed: form.isBlank == true
                              ? null
                              : () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1970),
                                    lastDate:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            DateTime.now()
                                                    .millisecondsSinceEpoch +
                                                315360000000),
                                    initialDate: form.dateTime,
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        form.dateTime = DateTime(
                                          value.year,
                                          value.month,
                                          value.day,
                                          form.dateTime.hour,
                                          form.dateTime.minute,
                                        );
                                        context
                                            .read<DateTimeDialogCubit>()
                                            .load();
                                      }
                                    },
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  FormatDate.dmy(form.dateTime),
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
                        Visibility(
                            visible: form.isBlank == true,
                            replacement: const SizedBox(),
                            child: Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorTheme.enabledButton(theme_),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            side: WidgetStatePropertyAll(
                                BorderSide(color: ColorTheme.item20(theme_))),
                            shape: const WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                            backgroundColor:
                                WidgetStatePropertyAll(ColorTheme.fill(theme_)),
                          ),
                          onPressed: form.isBlank == true
                              ? null
                              : () {
                                  showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(form.dateTime),
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        form.dateTime = DateTime(
                                          form.dateTime.year,
                                          form.dateTime.month,
                                          form.dateTime.day,
                                          value.hour,
                                          value.minute,
                                        );
                                        context
                                            .read<DateTimeDialogCubit>()
                                            .load();
                                      }
                                    },
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  FormatDate.hm(
                                      TimeOfDay.fromDateTime(form.dateTime)),
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
                        Visibility(
                            visible: form.isBlank == true,
                            replacement: const SizedBox(),
                            child: Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorTheme.enabledButton(theme_),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Visibility(
                    visible: isBlank != null,
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: ColorTheme.item20(theme_),
                          side: BorderSide(
                              color: ColorTheme.item20(theme_), width: 2),
                          value: form.isBlank,
                          onChanged: (value) {
                            if (value != null) {
                              form.isBlank = value;
                              context.read<DateTimeDialogCubit>().load();
                            }
                          },
                        ),
                        Text(
                          'Marcar para vaciar campo.',
                          style: Typo.body(theme_),
                        )
                      ],
                    )),
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

  Future<void> initLoad(
      DateTimeDialogFormModel form, DateTime dateTime, bool isBlank) async {
    try {
      emit(DateTimeDialogState.init);
      emit(DateTimeDialogState.loading);
      form = DateTimeDialogFormModel(dateTime: dateTime, isBlank: isBlank);
      emit(DateTimeDialogState.loaded);
    } catch (e) {
      emit(DateTimeDialogState.init);
      // ignore: avoid_print
      print(e);
      emit(DateTimeDialogState.error);
    }
  }
}

class DateTimeDialogForm extends Cubit<DateTimeDialogFormModel> {
  DateTimeDialogForm(DateTime dateTime, bool isBlank)
      : super(DateTimeDialogFormModel(dateTime: dateTime, isBlank: isBlank));
}

class DateTimeDialogFormModel {
  DateTime dateTime;
  bool isBlank;

  DateTimeDialogFormModel({required this.dateTime, required this.isBlank});
}
