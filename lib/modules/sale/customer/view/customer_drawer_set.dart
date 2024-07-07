<<<<<<< HEAD:lib/modules/sale/customer/view/customer_drawer_add.dart
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/textfield_input_form.dart';
import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../cubit/customer_add/customer_add_cubit.dart';
import '../cubit/customer_add/customer_add_form.dart';
import '../cubit/customer_add/customer_add_state.dart';
import '../model/customer_add_form_model.dart';

class CustomerDrawerAdd extends StatelessWidget {
  const CustomerDrawerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerAddFormModel form = context.read<CustomerAddForm>().state;

    return BlocConsumer<CustomerAddCubit, CustomerAddState>(
      bloc: context.read<CustomerAddCubit>()..loadAvailableId(form),
      listener: (context, state) {
        if (state is ErrorCustomerAddState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedCustomerAddState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        form = context.read<CustomerAddForm>().state;
        if (state is LoadedCustomerAddState) {
          return loadDrawerBox(state.form, context, false, state.focusIndex);
        } else if (state is LoadingCustomerAddState) {
          return loadDrawerBox(form, context, true, -1);
        } else {
          return loadDrawerBox(form, context, false, -1);
        }
      },
    );
  }

  DrawerBox loadDrawerBox(CustomerAddFormModel form, BuildContext context,
      bool isLoading, int focusIndex) {
    CustomerAddFormModel upForm = form;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
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
          upForm = CustomerAddFormModel.listToForm(listForm);
          context.read<CustomerAddForm>().setForm(upForm);
        },
        onSubmitted: (value) {
          element.isLoading = true;
          listForm[i] = element;
          upForm = CustomerAddFormModel.listToForm(listForm);
          final nextFocus = i + 1;
          context
              .read<CustomerAddCubit>()
              .loadSingleValidationEnter(upForm, element.key, nextFocus);
        },
      ));
      listWidget.add(widget);
    }
    drawerBox = DrawerBox(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      header: Column(
        children: [
          const Text(
            'Nuevo Cliente',
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
            context.read<CustomerAddCubit>().save(form);
          },
        ),
      ],
      children: listWidget,
    );
    return drawerBox;
  }
}
=======
import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/textfield_input_form.dart';
import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../cubit/customer_add/customer_set_cubit.dart';
import '../cubit/customer_add/customer_add_form.dart';
import '../cubit/customer_add/customer_add_state.dart';
import '../model/customer_add_form_model.dart';

class CustomerDrawerSet extends StatelessWidget {
  final CustomerModel? customerEdit;
  const CustomerDrawerSet({super.key, this.customerEdit});

  @override
  Widget build(BuildContext context) {
    CustomerAddFormModel form = context.read<CustomerAddForm>().state;

    return BlocConsumer<CustomerSetCubit, CustomerAddState>(
      bloc: context.read<CustomerSetCubit>()..initLoad(form, customerEdit),
      listener: (context, state) {
        if (state is ErrorCustomerAddState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedCustomerAddState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        form = context.read<CustomerAddForm>().state;
        if (state is LoadedCustomerAddState) {
          return loadDrawerBox(
              state.form, context, false, state.focusIndex, customerEdit);
        } else if (state is LoadingCustomerAddState) {
          return loadDrawerBox(form, context, true, -1, customerEdit);
        } else {
          return loadDrawerBox(form, context, false, -1, customerEdit);
        }
      },
    );
  }

  DrawerBox loadDrawerBox(CustomerAddFormModel form, BuildContext context,
      bool isLoading, int focusIndex, CustomerModel? customerEdit) {
    CustomerAddFormModel upForm = form;
    List<TextfieldFormModel> listForm = CustomerAddFormModel.formToList(form);
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
          upForm = CustomerAddFormModel.listToForm(listForm);
          context.read<CustomerAddForm>().setForm(upForm);
        },
        onSubmitted: (value) {
          element.isLoading = true;
          listForm[i] = element;
          upForm = CustomerAddFormModel.listToForm(listForm);
          final nextFocus = i + 1;
          context
              .read<CustomerSetCubit>()
              .loadSingleValidationEnter(upForm, element.key, nextFocus);
        },
      ));
      listWidget.add(widget);
    }
    drawerBox = DrawerBox(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      header: Column(
        children: [
          Text(
            customerEdit != null ? 'Editar cliente' : 'Nuevo Cliente',
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
            context.read<CustomerSetCubit>().save(form, customerEdit);
          },
        ),
      ],
      children: listWidget,
    );
    return drawerBox;
  }
}
>>>>>>> main:lib/modules/sale/customer/view/customer_drawer_set.dart
