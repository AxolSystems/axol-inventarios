import 'package:axol_inventarios/modules/sale/sale_note/cubit/salenote_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../../../../models/validation_form_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/salenote_drawer_cubit/salenote_drawer_cubit.dart';
import '../../cubit/salenote_drawer_cubit/salenote_drawer_state.dart';
import '../../model/saelnote_add_form_model.dart';
import '../widgets/drawer_sale_note/drawer_sale_note.dart';

/*class DrawerNotesController extends StatelessWidget {
  const DrawerNotesController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalenoteDrawerCubit, SalenoteDrawerState>(
      bloc: context.read<SalenoteDrawerCubit>()..initial(),
      builder: (context, state) {
        List<String> listResponse;
        SaleNoteAddFormModel? salenoteForm;
        if (state is LoadingState) {
          return const DrawerSalenote(
            isLoading: true,
          );
        } else if (state is LoadedState) {
          listResponse = state.response;
          if (listResponse.isNotEmpty) {
            salenoteForm = _changeSalenoteForm(
              listResponse,
              state.modelMap,
              context.read<SalenoteFormCubit>().state,
            );
            context.read<SalenoteFormCubit>().setForm(salenoteForm);
          }
          return const DrawerSalenote(
            isLoading: false,
          );
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: Typo.labelText1,
          );
        }
        return Text(
          'No emitio nada...',
          style: Typo.labelText1,
        );
      },
    );
  }
}

SaleNoteAddFormModel _changeSalenoteForm(List<String> response,
    Map<int, dynamic> modelMap, SaleNoteAddFormModel currentForm) {
  SaleNoteAddFormModel salenoteForm = currentForm;
  List elementsList;
  for (var element in response) {
    elementsList = element.split(':');
    if (elementsList.first == SaleNoteAddFormModel.pCustomer) {
      salenoteForm.customer = _changeSalenoteTextfield(
          elementsList.elementAt(1),
          currentForm.customer,
          elementsList.elementAt(2));
    } else if (elementsList.first == SaleNoteAddFormModel.pVendor) {
      salenoteForm.vendor = _changeSalenoteTextfield(elementsList.elementAt(1),
          currentForm.vendor, elementsList.elementAt(2));
    } else if (elementsList.first == SaleNoteAddFormModel.pWarehouse) {
      salenoteForm.warehouse = _changeSalenoteTextfield(
          elementsList.elementAt(1),
          currentForm.warehouse,
          elementsList.elementAt(2));
    } else if (elementsList.first == SaleNoteAddFormModel.pCustomerModel) {
      salenoteForm.customerModel = modelMap[0];
    } else if (elementsList.first == SaleNoteAddFormModel.pVendorModel) {
      salenoteForm.vendorModel = modelMap[1];
    } else if (elementsList.first == SaleNoteAddFormModel.pWarehouseModel) {
      salenoteForm.warehouseModel = modelMap[2];
    }
  }
  return salenoteForm;
}

TextfieldFormModel _changeSalenoteTextfield(
    String elementKey, TextfieldFormModel currentTextField, String? response) {
  TextfieldFormModel textfieldForm = currentTextField;
  List<String> responseList = [];
  if (response != null) {
    responseList = response.split('/');
  }
  if (elementKey == TextfieldFormModel.pValidation) {
    if (responseList.first == 'true') {
      textfieldForm.validation =
          ValidationFormModel(isValid: true, errorMessage: '');
    } else if (responseList.first == 'false') {
      textfieldForm.validation =
          ValidationFormModel(isValid: false, errorMessage: responseList.last);
    }
  }
  return textfieldForm;
}*/
