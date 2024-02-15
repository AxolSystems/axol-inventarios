import 'package:axol_inventarios/models/textfield_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/toolbar.dart';
import '../../../../../models/elemnets_bar_model.dart';
import '../../cubit/movement_filters/movement_filters_cubit.dart';
import '../../cubit/movements_view/movements_cubit.dart';
import '../../model/movement_filter_model.dart';
import '../../model/movement_model.dart';
import '../controllers/drawer_history_controller.dart';
import '../controllers/drawer_movement_controller.dart';
import 'pdf_movements_format.dart';
import 'pdf_preview_page.dart';

/*class ToolbarMovements extends StatelessWidget {
  final List<MovementModel> movementsList;
  final bool isLoading;
  final MovementFilterModel currentFilter;
  final int mode;
  const ToolbarMovements(
      {super.key,
      required this.isLoading,
      required this.currentFilter,
      required this.movementsList,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    return Toolbar(
      listData: [
        /*ElementsBarModel(
          text: null,
          icon: const Icon(Icons.add),
          action: () {},
        ),*/
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.filter_alt),
          action: () {
            if (isLoading == false && mode == 0) {
              showDialog(
                context: context,
                builder: (context) => BlocProvider(
                    create: (_) => MovementFiltersCubit(),
                    child: DrawerMovementsController(
                      currentFilter: currentFilter,
                    )),
              ).then((value) {
                if (value != null) {
                  context
                      .read<MovementsCuibit>()
                      .filterMode(value, TextfieldModel(text: '', position: 0));
                }
                //print(value);
              });
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.restart_alt),
          action: () {
            if (isLoading == false) {
              context.read<MovementsCuibit>().loadList();
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.picture_as_pdf),
          action: () {
            if (isLoading == false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                            makePdf: mode == 1
                                ? PdfMovementsFormats()
                                    .pdfHistory(movementsList)
                                : PdfMovementsFormats()
                                    .pdfMovements(movementsList),
                          )));
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.history_edu),
          secondaryColor: mode == 1 ? Colors.white : null,
          action: () {
            if (isLoading == false) {
              showDialog(
                context: context,
                builder: (context) => BlocProvider(
                    create: (_) => MovementFiltersCubit(),
                    child: DrawerHistoryController(
                      currentFilter: mode == 1
                          ? currentFilter
                          : MovementFilterModel.initialValue(),
                    )),
              ).then((value) {
                if (value != null) {
                  context.read<MovementsCuibit>().historyMode(
                      value, TextfieldModel(text: '', position: 0));
                }
              });
            }
          },
        )
      ],
    );
  }
}*/
