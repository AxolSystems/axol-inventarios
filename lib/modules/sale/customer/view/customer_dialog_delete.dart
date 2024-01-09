import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/progress_indicator.dart';
import '../cubit/customer_delete/customer_delete_cubit.dart';
import '../cubit/customer_delete/customer_delete_state.dart';
import '../model/customer_model.dart';

class CustomerDialogDelete extends StatelessWidget {
  final CustomerModel customer;
  const CustomerDialogDelete({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerDeleteCubit, CustomerDeleteState>(
      bloc: context.read<CustomerDeleteCubit>()..load(),
      listener: (context, state) {
        if (state is CloseCustomerDeleteState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoadedCustomerDeleteState) {
          return customerDialogDelete(context, customer);
        } else if (state is LoadingCustomerDeleteState) {
          return const Center(
            child: LinearProgressIndicatorAxol(),
          );
        } else if (state is ErrorCustomerDeleteState) {
          return AlertDialogAxol(text: state.error,);
        } else {
          return const AlertDialogAxol(text: 'Estado no recibido',);
        }
      },
    );
  }

  AlertDialogAxol customerDialogDelete(BuildContext context, CustomerModel customer) {
    const String message =
        '¿Estás seguro de eliminar este cliente?\n Esta acción no se podrá desasear';
    final List<Widget> actions = [
      ButtonReturnDialog(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ButtonDelete(onPressed: () {
        context.read<CustomerDeleteCubit>().deleteCustomer(customer);
      }),
    ];
    return AlertDialogAxol(
      text: message,
      actions: actions,
    );
  }
}
