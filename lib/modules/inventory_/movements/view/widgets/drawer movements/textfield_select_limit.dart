import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/movement_filters/movement_filters_cubit.dart';
import '../../../model/movement_filter_model.dart';

/*class TextfieldSelectLimit extends StatelessWidget {
  final MovementFilterModel filter;
  //{'limit': int, 'position': int}

  const TextfieldSelectLimit({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    String text = filter.currentLimit!.text;
    int limit = int.parse(filter.currentLimit!.text);
    int position = filter.currentLimit!.position;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
      text: limit.toString(),
      selection: TextSelection.collapsed(offset: position),
    );
    return SizedBox(
      width: 250,
      height: 40,
      child: TextField(
        controller: textController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        onTapOutside: (event) {
          if (int.tryParse(text) != null) {
            if (int.parse(text) == 0) {
              context.read<MovementFiltersCubit>().changeLimit(
                  filter, 1, textController.selection.base.offset + 1);
            } else {
              context.read<MovementFiltersCubit>().changeLimit(filter,
                  int.tryParse(text)!, textController.selection.base.offset);
            }
          } else if (text == '') {
            context.read<MovementFiltersCubit>().changeLimit(
                filter, 1, textController.selection.base.offset + 1);
          }
        },
        onSubmitted: (value) {
          if (int.tryParse(value) != null) {
            if (int.parse(value) == 0) {
              context.read<MovementFiltersCubit>().changeLimit(
                  filter, 1, textController.selection.base.offset + 1);
            } else {
              context.read<MovementFiltersCubit>().changeLimit(filter,
                  int.tryParse(value)!, textController.selection.base.offset);
            }
          } else if (value == '') {
            context.read<MovementFiltersCubit>().changeLimit(
                filter, 1, textController.selection.base.offset + 1);
          }
        },
        onChanged: (value) {
          text = value;
        },
      ),
    );
  }
}*/
