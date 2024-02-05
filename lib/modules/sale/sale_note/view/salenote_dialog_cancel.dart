import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/salenote_delete/salenote_cancel_cubit.dart';
import '../cubit/salenote_delete/salenote_cancel_state.dart';
import '../model/sale_note_model.dart';

class SaleNoteDialogCancel extends StatelessWidget {
  final SaleNoteModel saleNote;
  const SaleNoteDialogCancel({super.key, required this.saleNote});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => SaleNoteCancelCubit()),
    ], child: SaleNoteDialogCancelBuild(saleNote: saleNote));
  }
}

class SaleNoteDialogCancelBuild extends StatelessWidget {
  final SaleNoteModel saleNote;
  const SaleNoteDialogCancelBuild({super.key, required this.saleNote});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteCancelCubit, SaleNoteCancelState>(
      bloc: context.read<SaleNoteCancelCubit>()..load(),
      listener: (context, state) {
        if (state is CloseSaleNoteCancelState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoadedSaleNoteDeleteState) {
          return customerDialogDelete(context, saleNote);
        } else if (state is LoadingSaleNoteCancelState) {
          return const Center(
            child: LinearProgressIndicatorAxol(),
          );
        } else if (state is ErrorSaleNoteCancelState) {
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
        '¿Estás seguro desea cancelar esta nota de venta?\n Esta acción no se podrá desasear';
    final List<Widget> actions = [
      ButtonReturnDialog(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ButtonDelete(
        text: 'Cancelar',
        onPressed: () {
          context.read<SaleNoteCancelCubit>().cancelSaleNote(customer);
        },
      ),
    ];
    return AlertDialogAxol(
      text: message,
      actions: actions,
    );
  }
}
