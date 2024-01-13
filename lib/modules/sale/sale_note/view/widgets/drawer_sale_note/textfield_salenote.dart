import 'package:axol_inventarios/modules/sale/sale_note/model/saelnote_add_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/textfield_form_model.dart';
import '../../../cubit/salenote_drawer_cubit/salenote_drawer_cubit.dart';
import '../../../cubit/salenote_form_cubit.dart';

class TextfieldSalenote extends StatelessWidget {
  final String label;
  final List<TextInputFormatter>? inputFormatter;
  final int keyFormElement;
  final bool isFocus;

  const TextfieldSalenote(
      {super.key,
      required this.label,
      this.inputFormatter,
      required this.keyFormElement,
      required this.isFocus});

  @override
  Widget build(BuildContext context) {
    SaleNoteAddFormModel currentForm;
    TextEditingController textController = TextEditingController();
    FocusNode focusNode = FocusNode();
    SaleNoteAddFormModel form = context.read<SalenoteFormCubit>().state;
    TextfieldFormModel formElement = TextfieldFormModel.empty();
    if (keyFormElement == 0) {
      formElement = form.customerTf;
    } else if (keyFormElement == 1) {
      formElement = form.vendorTf;
    } else if (keyFormElement == 2) {
      formElement = form.warehouseTf;
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
          width: 300,
          child: Row(
            children: [
              Expanded(
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
                  currentForm = context.read<SalenoteFormCubit>().state;
                  context
                      .read<SalenoteDrawerCubit>()
                      .change(currentForm, keyFormElement);
                },
                onChanged: (value) {
                  context.read<SalenoteFormCubit>().change(
                        value,
                        textController.selection.base.offset,
                        keyFormElement,
                      );
                },
              )),
              IconButton(
                onPressed: () {
                  /*if (true) {
                    showDialog(
                      context: context,
                      builder: (context) => MultiBlocProvider(providers: [
                        BlocProvider(create: (_) => DrawerSearchCubit()),
                      ], child: DrawerSearchController()),
                    ).then((value) {});
                  }*/
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        )
      ],
    );
  }
}
