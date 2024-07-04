import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/routcustomer cubit/routcustomer_cubit.dart';

class FinderRc extends StatelessWidget {
  final TextfieldModel currentFinder;
  final bool isLoading;

  const FinderRc({
    super.key,
    required this.currentFinder,
    required this.isLoading,
  });

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
                //autofocus: true,
                enabled: !isLoading,
                onFieldSubmitted: (value) {
                  final textFinder = TextfieldModel(
                    text: value,
                    position: textController.selection.base.offset,
                  );
                  context.read<RoutcustomerCubit>().load(textFinder);
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
              final textFinder = TextfieldModel(
                text: text,
                position: textController.selection.base.offset,
              );
              context.read<RoutcustomerCubit>().load(textFinder);
            },
          ),
          IconButton(
            iconSize: 30,
            color: ColorPalette.darkText,
            icon: const Icon(
              Icons.cancel,
            ),
            onPressed: () {
              if (text != '') {
                context
                    .read<RoutcustomerCubit>()
                    .load(TextfieldModel.empty());
              }
            },
          ),
        ],
      ),
    );
  }
}
