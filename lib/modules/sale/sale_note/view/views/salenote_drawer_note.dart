import 'package:axol_inventarios/utilities/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../../utilities/widgets/button.dart';
import '../../../../../utilities/widgets/drawer_box.dart';
import '../../cubit/salenote_note/salenote_note_cubit.dart';
import '../../cubit/salenote_note/salenote_note_state.dart';
import '../../model/salenote_row_form_model.dart';

class SaleNoteDrawerNote extends StatelessWidget {
  final SaleNoteRowFormModel row;
  const SaleNoteDrawerNote({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteNoteCubit, SaleNoteNoteState>(
      bloc: context.read<SaleNoteNoteCubit>()..load(),
      listener: (context, state) {
        if (state is ErrorSaleNoteNoteState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingSaleNoteNoteState) {
          return saleNoteDrawerNote(context, true, row);
        } else if (state is LoadedSaleNoteNoteState) {
          return saleNoteDrawerNote(context, false, row);
        } else {
          return saleNoteDrawerNote(context, false, row);
        }
      },
    );
  }

  Widget saleNoteDrawerNote(
      BuildContext context, bool isLoading, SaleNoteRowFormModel row) {
    TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(
            text: row.note,
            selection: TextSelection.collapsed(offset: row.note.length)));
    return DrawerBox(
      header: Column(
        children: [
          const Text(
            'Nota',
            style: Typo.subtitleDark,
          ),
          Visibility(
            visible: isLoading,
            replacement: const SizedBox(height: 4),
            child: const LinearProgressIndicatorAxol(),
          )
        ],
      ),
      actions: [
        ButtonReturnDialog(
          isLoading: isLoading,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ButtonDrawerSave(
          isLoading: isLoading,
          onPressed: () {
            row.note = controller.value.text;
            Navigator.pop(context, row);
          },
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            enabled: !isLoading,
            controller: controller,
            maxLines: null,
            style: Typo.bodyDark,
            cursorColor: ColorPalette.primary,
            decoration: const InputDecoration(
              labelText: 'Nota',
              labelStyle: Typo.labelLight,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: ColorPalette.lightItems,
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: ColorPalette.primary,
              )),
            ),
          ),
        )
      ],
    );
  }
}
