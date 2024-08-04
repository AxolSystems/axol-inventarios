import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/salenote_delete/salenote_cancel_cubit.dart';
import '../cubit/salenote_delete/salenote_cancel_state.dart';
import '../model/sale_note_model.dart';

class SaleNoteDialogCancel extends StatelessWidget {
  final SaleNoteModel saleNote;
  final int saleType;
  const SaleNoteDialogCancel(
      {super.key, required this.saleNote, required this.saleType});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SaleNoteCancelCubit()),
        ],
        child: SaleNoteDialogCancelBuild(
          saleNote: saleNote,
          saleType: saleType,
        ));
  }
}

class SaleNoteDialogCancelBuild extends StatelessWidget {
  final SaleNoteModel saleNote;
  final int saleType;
  const SaleNoteDialogCancelBuild(
      {super.key, required this.saleNote, required this.saleType});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteCancelCubit, SaleNoteCancelState>(
      bloc: context.read<SaleNoteCancelCubit>()..load(),
      listener: (context, state) {
        if (state is CloseSaleNoteCancelState) {
          Navigator.pop(context);
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        if (state is LoadedSaleNoteDeleteState) {
          return saleNoteDialogDelete(context, saleNote);
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

  AlertDialogAxol saleNoteDialogDelete(
      BuildContext context, SaleNoteModel saleNote) {
    String saleTypeText = '-';
    String message;
    if (saleType == 0) {
      saleTypeText = 'nota de venta';
    }
    if (saleType == 1) {
      saleTypeText = 'remisión';
    }
    message =
        '¿Estás seguro desea cancelar esta $saleTypeText?\n Esta acción no se podrá desasear';
    final List<Widget> actions = [
      SecondaryButtonDialog(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      AlertButtonDialog(
        text: 'Cancelar',
        onPressed: () {
          context
              .read<SaleNoteCancelCubit>()
              .cancelSaleNote(saleNote, saleType);
        },
      ),
    ];
    return AlertDialogAxol(
      text: message,
      actions: actions,
    );
  }
}
