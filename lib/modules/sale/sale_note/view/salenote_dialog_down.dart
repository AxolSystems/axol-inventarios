import 'package:axol_inventarios/modules/sale/sale_note/model/salenote_filter_model.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/buttons/button.dart';
import '../cubit/snt_down_dialog.dart/snt_down_dialog_cubit.dart';
import '../cubit/snt_down_dialog.dart/snt_down_dialog_state.dart';

class SaleNoteDialogDown extends StatelessWidget {
  final int regCount;
  final int saleType;
  final SaleFilterModel filter;
  const SaleNoteDialogDown(
      {super.key,
      required this.regCount,
      required this.saleType,
      required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SntDownDialogCubit(),
      child: SaleNoteDialogDownBuild(
        regCount: regCount,
        saleType: saleType,
        filter: filter,
      ),
    );
  }
}

class SaleNoteDialogDownBuild extends StatelessWidget {
  final int regCount;
  final int saleType;
  final SaleFilterModel filter;
  const SaleNoteDialogDownBuild(
      {super.key,
      required this.regCount,
      required this.saleType,
      required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SntDownDialogCubit, SntDownDialogState>(
      bloc: context.read<SntDownDialogCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSntDownDialogState) {
          return saleNoteDialogDown(context, state.btnDownLoading, regCount);
        } else if (state is DownloadedSntDownDialogState) {
          return saleNoteDialogDown(context, false, regCount);
        } else {
          return saleNoteDialogDown(context, false, regCount);
        }
      },
      listener: (context, state) {
        if (state is ErrorSntDownDialogState) {
          AlertDialogAxol(text: state.error);
        }
        if (state is DownloadedSntDownDialogState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget saleNoteDialogDown(
      BuildContext context, bool btnDownLoading, int regCount) {
    return AlertDialogAxol(
      text: regCount <= 1000
          ? 'Se descargarán $regCount registros.'
          : 'Se encontraron $regCount registros, pero solo se descargarán los primeros 1000 registros.',
      actions: [
        SecondaryButtonDialog(
          text: 'Regresar',
          enabled: btnDownLoading,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PrimaryButtonDialog(
          text: 'Descargar',
          loading: btnDownLoading,
          onPressed: () {
            context.read<SntDownDialogCubit>().down(saleType, filter);
          },
        )
      ],
    );
  }
}
