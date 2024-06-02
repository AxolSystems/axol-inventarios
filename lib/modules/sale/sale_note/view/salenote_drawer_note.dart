import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../cubit/salenote_note/salenote_note_cubit.dart';
import '../cubit/salenote_note/salenote_note_state.dart';
import '../model/salenote_row_form_model.dart';

class SaleNoteNote extends StatelessWidget {
  final SaleNoteRowFormModel? row;
  final String? textNote;
  const SaleNoteNote({
    super.key,
    this.row,
    this.textNote,
  });

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SaleNoteNoteCubit()),
          ],
          child: SaleNoteDrawerNoteBuild(
            row: row,
            textNote: textNote,
          ));
}

class SaleNoteDrawerNoteBuild extends StatelessWidget {
  final SaleNoteRowFormModel? row;
  final String? textNote;
  const SaleNoteDrawerNoteBuild({super.key, this.row, this.textNote});

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
          return saleNoteDrawerNote(context, true, row, textNote);
        } else if (state is LoadedSaleNoteNoteState) {
          return saleNoteDrawerNote(context, false, row, textNote);
        } else {
          return saleNoteDrawerNote(context, false, row, textNote);
        }
      },
    );
  }

  Widget saleNoteDrawerNote(BuildContext context, bool isLoading,
      SaleNoteRowFormModel? row, String? tenxtNote) {
    String textNote_ = textNote ?? '';
    TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(
            text: row?.note ?? textNote_,
            selection: TextSelection.collapsed(
                offset: row?.note.length ?? textNote_.length)));
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
        SecondaryButtonDialog(
          enabled: isLoading,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PrimaryButtonDialog(
          enabled: isLoading,
          onPressed: () {
            if (row == null) {
              textNote_ = controller.value.text;
              Navigator.pop(context, textNote_);
            } else {
              row.note = controller.value.text;
              Navigator.pop(context, row);
            }
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
                color: ColorPalette.lightItems10,
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
