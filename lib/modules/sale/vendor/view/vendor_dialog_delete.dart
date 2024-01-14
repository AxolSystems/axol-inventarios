import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/progress_indicator.dart';
import '../cubit/vendor_delete/customer_delete_cubit.dart';
import '../cubit/vendor_delete/vendor_delete_state.dart';
import '../model/vendor_model.dart';

class VendorDialogDelete extends StatelessWidget {
  final VendorModel vendor;
  const VendorDialogDelete({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorDeleteCubit, VendorDeleteState>(
      bloc: context.read<VendorDeleteCubit>()..load(),
      listener: (context, state) {
        if (state is CloseVendorDeleteState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoadedVendorDeleteState) {
          return customerDialogDelete(context, vendor);
        } else if (state is LoadingVendorDeleteState) {
          return const Center(
            child: LinearProgressIndicatorAxol(),
          );
        } else if (state is ErrorVendorDeleteState) {
          return AlertDialogAxol(text: state.error,);
        } else {
          return const AlertDialogAxol(text: 'Estado no recibido',);
        }
      },
    );
  }

  AlertDialogAxol customerDialogDelete(BuildContext context, VendorModel customer) {
    const String message =
        '¿Estás seguro de eliminar este vendedor?\n Esta acción no se podrá desasear';
    final List<Widget> actions = [
      ButtonReturnDialog(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ButtonDelete(onPressed: () {
        context.read<VendorDeleteCubit>().deleteCustomer(customer);
      }),
    ];
    return AlertDialogAxol(
      text: message,
      actions: actions,
    );
  }
}
