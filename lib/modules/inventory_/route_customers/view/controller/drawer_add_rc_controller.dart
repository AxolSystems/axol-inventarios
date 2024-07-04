import 'package:axol_inventarios/models/textfield_form_model.dart';
import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/model/rc_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/theme/theme.dart';
import '../../cubit/rc_drawer_cubit/rc_drawer_cubit.dart';
import '../../cubit/rc_drawer_cubit/rc_drawer_state.dart';
import '../widgets/drawer_add_rc.dart';

class DrawerAddRcController extends StatelessWidget {
  const DrawerAddRcController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RcDrawerCubit, RcDrawerState>(
      bloc: context.read<RcDrawerCubit>()..initial(),
      builder: (context, state) {
        List<String> response;
        List<String> list;
        if (state is LoadingState) {
          // ignore: prefer_const_constructors
          return DrawerAddRc(
            isLoading: true,
          );
        } else if (state is LoadedState) {
          response = state.response;
          RcFormModel rcForm = context.read<RcFormCubit>().state;
          if (response.isNotEmpty) {
            for (var element in response) {
              list = element.split(':');
              if (list.first == 'validation') {
                if (list.last.split('/').first == 'false') {
                  rcForm.id = TextfieldFormModel(
                    position: rcForm.id.position,
                    validation: ValidationFormModel(
                      isValid: false,
                      errorMessage: list.last.split('/').last,
                    ),
                    value: rcForm.id.value,
                    key: '',
                    controller: TextEditingController(),
                    isLoading: false,
                    tags: [],
                  );
                }
              } else if (list.first == 'user') {
                rcForm.user = list.last;
              }
              context.read<RcFormCubit>().setForm(rcForm);
            }
          }
          // ignore: prefer_const_constructors
          return DrawerAddRc(
            isLoading: false,
          );
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: Typo.labelText1,
          );
        }
        return const Text(
          'No emitio nada...',
          style: Typo.labelText1,
        );
      },
    );
  }
}
