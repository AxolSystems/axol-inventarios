import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/movements_view/movements_cubit.dart';
import '../../model/movement_filter_model.dart';

class TextfieldFinderMovement extends StatelessWidget {
  final TextfieldModel currentFinder;
  final bool isLoading;
  final MovementFilterModel filters;

  const TextfieldFinderMovement(
      {super.key,
      required this.currentFinder,
      required this.isLoading,
      required this.filters});

  @override
  Widget build(BuildContext context) {
    String text = currentFinder.text;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: currentFinder.text,
        selection: TextSelection.collapsed(offset: currentFinder.position));

    return Container(
      color: ColorPalette.lightBackground,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: TextFormField(
                controller: textController,
                autofocus: true,
                enabled: isLoading,
                onFieldSubmitted: (value) {
                  context.read<MovementsCuibit>().filterMode(
                      filters,
                      TextfieldModel(
                          text: value,
                          position: textController.selection.base.offset));
                },
                onChanged: (value) {
                  text = value;
                },
                decoration: InputDecoration(
                    hintText: 'Buscar',
                    hintStyle: Typo.hintText,
                    filled: true,
                    fillColor: ColorPalette.lightBackground,
                    border: InputBorder.none),
                style: Typo.textField1,
              ),
            ),
          ),
          IconButton(
            iconSize: 30,
            color: ColorPalette.darkText,
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              context.read<MovementsCuibit>().filterMode(
                  filters,
                  TextfieldModel(
                      text: text,
                      position: textController.selection.base.offset));
            },
          ),
          IconButton(
            iconSize: 30,
            color: ColorPalette.darkText,
            icon: const Icon(
              Icons.cancel,
            ),
            onPressed: () {
              context
                  .read<MovementsCuibit>()
                  .filterMode(filters, TextfieldModel(text: '', position: 0));
            },
          ),
        ],
      ),
    );
  }
}
