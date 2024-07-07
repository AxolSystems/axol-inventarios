<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/button.dart';
import '../cubit/inventory_dialog_save/inventory_dialog_save_cubit.dart';
import '../cubit/inventory_dialog_save/inventory_dialog_save_state.dart';
import '../model/report_inventory_move_model.dart';

class InventoryMoveDialogSave extends StatelessWidget {
  final ReportInventoryMoveModel reportData;
  const InventoryMoveDialogSave({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryDialogSaveCubit(),
      child: InventoryMoveDialogSaveBuild(reportData: reportData),
    );
  }
}

class InventoryMoveDialogSaveBuild extends StatelessWidget {
  final ReportInventoryMoveModel reportData;
  const InventoryMoveDialogSaveBuild({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryDialogSaveCubit, InventoryDialogSaveState>(
      bloc: context.read<InventoryDialogSaveCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingInventoryDialogSaveState) {
          return inventoryMoveDialogSave(context, true, reportData);
        } else if (state is LoadedInventoryDialogSaveState) {
          return inventoryMoveDialogSave(context, false, reportData);
        } else {
          return inventoryMoveDialogSave(
              context, false, ReportInventoryMoveModel.empty());
        }
      },
    );
  }

  Widget inventoryMoveDialogSave(
    BuildContext context,
    bool isLoading,
    ReportInventoryMoveModel reportData,
  ) {
    return AlertDialogAxol(
      text: 'Guardado',
      icon: Icons.check_circle,
      iconColor: ColorPalette.correct,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      actions: [
        PrimaryButtonDialog(
          text: 'Aceptar',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        SecondaryButtonDialog(
          enabled: isLoading,
          text: 'Descargar PDF',
          onPressed: () {
            if (reportData.concept.id == 58) {
              context
                  .read<InventoryDialogSaveCubit>()
                  .downloadTransferPdf(reportData);
            } else {
              context
                  .read<InventoryDialogSaveCubit>()
                  .downloadSingleMovePdf(reportData);
            }
          },
        )
      ],
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../cubit/inventory_dialog_save/inventory_dialog_save_cubit.dart';
import '../cubit/inventory_dialog_save/inventory_dialog_save_state.dart';
import '../model/report_inventory_move_model.dart';

class InventoryMoveDialogSave extends StatelessWidget {
  final ReportInventoryMoveModel reportData;
  const InventoryMoveDialogSave({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryDialogSaveCubit(),
      child: InventoryMoveDialogSaveBuild(reportData: reportData),
    );
  }
}

class InventoryMoveDialogSaveBuild extends StatelessWidget {
  final ReportInventoryMoveModel reportData;
  const InventoryMoveDialogSaveBuild({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryDialogSaveCubit, InventoryDialogSaveState>(
      bloc: context.read<InventoryDialogSaveCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingInventoryDialogSaveState) {
          return inventoryMoveDialogSave(context, true, reportData);
        } else if (state is LoadedInventoryDialogSaveState) {
          return inventoryMoveDialogSave(context, false, reportData);
        } else {
          return inventoryMoveDialogSave(
              context, false, ReportInventoryMoveModel.empty());
        }
      },
    );
  }

  Widget inventoryMoveDialogSave(
    BuildContext context,
    bool isLoading,
    ReportInventoryMoveModel reportData,
  ) {
    return AlertDialogAxol(
      text: 'Guardado',
      icon: Icons.check_circle,
      iconColor: ColorPalette.correct,
      onPressed: () {
        Navigator.pop(context);
      },
      actions: [
        PrimaryButtonDialog(
          text: 'Aceptar',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SecondaryButtonDialog(
          enabled: isLoading,
          text: 'Descargar PDF',
          onPressed: () {
            if (reportData.concept.id == 58) {
              context
                  .read<InventoryDialogSaveCubit>()
                  .downloadTransferPdf(reportData);
            } else {
              context
                  .read<InventoryDialogSaveCubit>()
                  .downloadSingleMovePdf(reportData);
            }
          },
        )
      ],
    );
  }
}
>>>>>>> main
