import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../cubit/sale_dialog_save/sale_dialog_save_cubit.dart';
import '../cubit/sale_dialog_save/sale_dialog_save_state.dart';
import '../model/sale_note_model.dart';
import '../model/sale_product_model.dart';

class SaleNoteDialogSave extends StatelessWidget {
  final SaleNoteModel saleNote;
  final List<SaleProductModel> productList;
  final int saleType;
  const SaleNoteDialogSave(
      {super.key,
      required this.saleNote,
      required this.productList,
      required this.saleType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SaleDialogSaveCubit(),
      child: SaleNoteDialogSaveBuild(
        saleNote: saleNote,
        productList: productList,
        saleType: saleType,
      ),
    );
  }
}

class SaleNoteDialogSaveBuild extends StatelessWidget {
  final SaleNoteModel saleNote;
  final List<SaleProductModel> productList;
  final int saleType;
  const SaleNoteDialogSaveBuild(
      {super.key,
      required this.saleNote,
      required this.productList,
      required this.saleType});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleDialogSaveCubit, SaleDialogSaveState>(
      bloc: context.read<SaleDialogSaveCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingSaleDialogSaveState) {
          return saleNoteDialogSave(context, true);
        } else if (state is LoadedSaleDialogSaveState) {
          return saleNoteDialogSave(context, false);
        } else {
          return saleNoteDialogSave(context, false);
        }
      },
      listener: (context, state) {
        
      },
    );
  }

  Widget saleNoteDialogSave(BuildContext context, bool isLoading) {
    return AlertDialogAxol(
      text: 'Guardado correctamente',
      icon: Icons.check_circle,
      iconColor: Colors.green,
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
              backgroundColor: ColorPalette.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)))),
          child: const Text(
            'Aceptar',
            style: Typo.bodyLight,
          ),
        ),
        SecondaryButtonDialog(
          enabled: isLoading,
          text: 'Descargar PDF',
          onPressed: () async {
            context.read<SaleDialogSaveCubit>().downloadPdf(saleNote, productList, saleType);
          },
        )
      ],
    );
  }
}
