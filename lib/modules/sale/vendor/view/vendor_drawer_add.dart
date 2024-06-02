import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/textfield_input_form.dart';
import '../../customer/model/customer_add_form_model.dart';
import '../cubit/vendor_add/vendor_add_cubit.dart';
import '../cubit/vendor_add/vendor_add_form.dart';
import '../cubit/vendor_add/vendor_add_state.dart';
import '../model/vendor_add_form_model.dart';

class VendorDrawerAdd extends StatelessWidget {
  const VendorDrawerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    VendorAddFormModel form = context.read<VendorAddForm>().state;

    return BlocConsumer<VendorAddCubit, VendorAddState>(
      bloc: context.read<VendorAddCubit>()..loadAvailableId(form),
      listener: (context, state) {
        if (state is ErrorVendorAddState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedVendorAddState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        form = context.read<VendorAddForm>().state;
        if (state is LoadedVendorAddState) {
          return vendorDrawerAdd(state.form, context, false, state.focusIndex);
        } else if (state is LoadingVendorAddState) {
          return vendorDrawerAdd(form, context, true, -1);
        } else {
          return vendorDrawerAdd(form, context, false, -1);
        }
      },
    );
  }

  Widget vendorDrawerAdd(VendorAddFormModel form, BuildContext context,
      bool isLoading, int focusIndex) {
    VendorAddFormModel upForm = form;
    List<TextfieldFormModel> listForm = VendorAddFormModel.formToList(form);
    List<Widget> listWidget = [];
    Material widget;
    DrawerBox drawerBox;
    List<TextInputFormatter> inputFormatters = [];
    for (int i = 0; i < listForm.length; i++) {
      var element = listForm[i];
      if (element.tags.contains(CustomerAddFormModel.tagInteger)) {
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
        ];
      } else {
        inputFormatters = [];
      }
      element.controller.value = TextEditingValue(
          text: element.value,
          selection: TextSelection.collapsed(offset: element.position));
      widget = Material(
          child: TextFieldInputForm(
        controller: element.controller,
        inputFormatters: inputFormatters,
        label: form.mapLbl[element.key],
        enabled: !isLoading,
        isFocus: focusIndex == i,
        errorText: element.validation.isValid == false
            ? element.validation.errorMessage
            : null,
        onChanged: (value) {
          element.value = value;
          element.position = element.controller.selection.base.offset;
          listForm[i] = element;
          upForm = VendorAddFormModel.listToForm(listForm);
          context.read<VendorAddForm>().setForm(upForm);
        },
        onSubmitted: (value) {
          element.isLoading = true;
          listForm[i] = element;
          upForm = VendorAddFormModel.listToForm(listForm);
          final nextFocus = i + 1;
          context
              .read<VendorAddCubit>()
              .loadSingleValidation(upForm, key: element.key, nextFocus: nextFocus);
        },
      ));
      listWidget.add(widget);
    }
    drawerBox = DrawerBox(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      header: Column(
        children: [
          const Text(
            'Nuevo Vendedor',
            style: Typo.subtitleDark,
          ),
          Visibility(
              visible: isLoading,
              replacement: const SizedBox(
                height: 4,
              ),
              child: const LinearProgressIndicatorAxol())
        ],
      ),
      actions: [
        SecondaryButtonDialog(
          enabled: isLoading,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PrimaryButtonDialog(
          enabled: isLoading,
          onPressed: () {
            context.read<VendorAddCubit>().save(form);
          },
        ),
      ],
      children: listWidget,
    );
    return drawerBox;
  }
}