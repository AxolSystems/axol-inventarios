import 'package:axol_inventarios/modules/inventory_/movements/cubit/movement_pdf/movement_pdf_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/movement_pdf/movement_pdf_cubit.dart';

class MovementDrawerPdf extends StatelessWidget {
  const MovementDrawerPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovementPdfCubit(),
      child: const MovementDrawerPdfBuild(),
    );
  }
}

class MovementDrawerPdfBuild extends StatelessWidget {
  const MovementDrawerPdfBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: context.read<MovementPdfCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingMovePdfState) {
          return movementDrawerPdf(context, true);
        } else if (state is LoadedMovePdfState) {
          return movementDrawerPdf(context, false);
        } else {
          return movementDrawerPdf(context, false);
        }
      },
      listener: (context, state) {
        if (state is ErrorMovePdfState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget movementDrawerPdf(BuildContext context, bool isLoading) {
    return DrawerBox(
      header: Column(
        children: [
          const Text(
            'Reporte de movimiento al inventario',
            style: Typo.titleDark,
          ),
          Visibility(
            visible: isLoading,
            replacement: const SizedBox(height: 4,),
            child: const LinearProgressIndicatorAxol(),
          ),
        ],
      ),
      actions: [
        SecondaryButtonDialog(),
      ],
      children: [
        Divider(
          color: ColorPalette.lightItems20,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pantalla actual',
                        style: Typo.boldLabelDark,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 120,
                        child: SecondaryButtonDialog(
                          text: 'Descargar',
                          textStyle: Typo.labelDark,
                          border: BorderSide(color: ColorPalette.lightItems10),
                          icon: Icon(
                            Icons.download,
                            color: ColorPalette.lightItems10,
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    'Descarga archivo PDF con los movimientos que se muestra en la pantalla actual de la lista de movimientos al inventario.',
                    style: Typo.smallLabelDark,
                  )),
            ],
          ),
        ),
        Divider(
          color: ColorPalette.lightItems20,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descarga por filtro', style: Typo.boldLabelDark),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 120,
                      child: SecondaryButtonDialog(
                        text: 'Descargar',
                        textStyle: Typo.labelDark,
                        border: BorderSide(color: ColorPalette.lightItems10),
                        icon: Icon(
                          Icons.download,
                          color: ColorPalette.lightItems10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documento',
                        style: Typo.labelDark,
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: TextField(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Filtra movimientos al inventario por documento. Separe por comas si quiere agregar más de un documento.',
                        style: Typo.smallLabelDark,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Folio',
                        style: Typo.labelDark,
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: TextField(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Filtra movimientos al inventario por número de folio. Separe por comas si quiere agregar más de un número de folio.',
                        style: Typo.smallLabelDark,
                      ),
                    ],
                  )),
              Divider(
                color: ColorPalette.lightItems20,
                height: 1,
                thickness: 1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
