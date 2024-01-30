import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../../utilities/widgets/button.dart';
import '../../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../cubit/salenote_delete/salenote_delete_cubit.dart';
import '../../cubit/salenote_delete/salenote_delete_state.dart';
import '../../model/sale_note_model.dart';

class SaleNoteDialogDelete extends StatelessWidget {
  final SaleNoteModel saleNote;
  const SaleNoteDialogDelete({super.key, required this.saleNote});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => SaleNoteDeleteCubit()),
    ], child: SaleNoteDialogDeleteBuild(saleNote: saleNote));
  }
}

class SaleNoteDialogDeleteBuild extends StatelessWidget {
  final SaleNoteModel saleNote;
  const SaleNoteDialogDeleteBuild({super.key, required this.saleNote});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteDeleteCubit, SaleNoteDeleteState>(
      bloc: context.read<SaleNoteDeleteCubit>()..load(),
      listener: (context, state) {
        if (state is CloseSaleNoteDeleteState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoadedSaleNoteDeleteState) {
          return customerDialogDelete(context, saleNote);
        } else if (state is LoadingSaleNoteDeleteState) {
          return const Center(
            child: LinearProgressIndicatorAxol(),
          );
        } else if (state is ErrorSaleNoteDeleteState) {
          return AlertDialogAxol(
            text: state.error,
          );
        } else {
          return const AlertDialogAxol(
            text: 'Estado no recibido',
          );
        }
      },
    );
  }

  AlertDialogAxol customerDialogDelete(
      BuildContext context, SaleNoteModel customer) {
    const String message =
        '¿Estás seguro de eliminar esta nota de venta?\n Esta acción no se podrá desasear';
    final List<Widget> actions = [
      ButtonReturnDialog(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ButtonDelete(onPressed: () {
        context.read<SaleNoteDeleteCubit>().deleteCustomer(customer);
      }),
    ];
    return AlertDialogAxol(
      text: message,
      actions: actions,
    );
  }
}
