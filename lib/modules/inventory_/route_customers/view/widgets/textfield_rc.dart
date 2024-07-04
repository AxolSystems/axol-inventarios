import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_drawer_cubit/rc_drawer_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/model/rc_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';

class TextfieldRc extends StatelessWidget {
  final String label;
  final List<TextInputFormatter>? inputFormatter;
  final int keyFormElement;
  final bool isFocus;
  final double? width;

  const TextfieldRc({
    super.key,
    required this.label,
    this.inputFormatter,
    required this.keyFormElement,
    required this.isFocus,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    RcFormModel currentForm;
    TextEditingController textController = TextEditingController();
    FocusNode focusNode = FocusNode();
    RcFormModel form = context.read<RcFormCubit>().state;
    TextfieldFormModel formElement = TextfieldFormModel.empty();
    if (keyFormElement == 0) {
      formElement = form.id;
    } else if (keyFormElement == 1) {
      formElement = form.name;
    } else if (keyFormElement == 2) {
      formElement = form.location;
    } else if (keyFormElement == 3) {
      formElement = form.address;
    } else if (keyFormElement == 4) {
      formElement = form.hood;
    } else if (keyFormElement == 5) {
      formElement = form.town;
    } else if (keyFormElement == 6) {
      formElement = form.country;
    } else if (keyFormElement == 7) {
      formElement = form.vendor;
    }

    textController.value = TextEditingValue(
        text: formElement.value,
        selection: TextSelection.collapsed(offset: formElement.position));
    if (isFocus) {
      focusNode.requestFocus();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        SizedBox(
            height: 40,
            width: width ?? 300,
            child: TextField(
              inputFormatters: inputFormatter,
              focusNode: focusNode,
              controller: textController,
              decoration: InputDecoration(
                isDense: true,
                errorStyle: const TextStyle(height: 0.3),
                errorText: formElement.validation.isValid
                    ? null
                    : formElement.validation.errorMessage,
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
              onSubmitted: (value) {
                currentForm = context.read<RcFormCubit>().state;
                if (keyFormElement == 0) {
                  context
                      .read<RcDrawerCubit>()
                      .changeCompareId(currentForm.id.value);
                } else {
                  context.read<RcFormCubit>().changeForm(
                        value,
                        textController.selection.base.offset,
                        keyFormElement,
                      );
                  context.read<RcDrawerCubit>().change();
                }
              },
              onChanged: (value) {
                context.read<RcFormCubit>().changeForm(
                      value,
                      textController.selection.base.offset,
                      keyFormElement,
                    );
              },
            ))
      ],
    );
  }
}
