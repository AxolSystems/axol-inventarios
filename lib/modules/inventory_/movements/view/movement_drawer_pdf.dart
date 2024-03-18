import 'dart:html';

import 'package:axol_inventarios/modules/inventory_/movements/cubit/movement_pdf/movement_pdf_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/movement_pdf/movement_pdf_cubit.dart';
import '../model/movement_model.dart';
import '../model/movement_pdf_form_model.dart';

class MovementDrawerPdf extends StatelessWidget {
  final List<MovementModel> movementList;
  const MovementDrawerPdf({super.key, required this.movementList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovementPdfCubit()),
        BlocProvider(create: (_) => MovementPdfForm()),
      ],
      child: MovementDrawerPdfBuild(movementList: movementList),
    );
  }
}

class MovementDrawerPdfBuild extends StatelessWidget {
  final List<MovementModel> movementList;
  const MovementDrawerPdfBuild({super.key, required this.movementList});

  @override
  Widget build(BuildContext context) {
    MovementPdfFormModel form = context.read<MovementPdfForm>().state;
    return BlocConsumer(
      bloc: context.read<MovementPdfCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingMovePdfState) {
          return movementDrawerPdf(context, true, [], form);
        } else if (state is LoadedMovePdfState) {
          return movementDrawerPdf(context, false, movementList, form);
        } else {
          return movementDrawerPdf(context, false, [], form);
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

  Widget movementDrawerPdf(
    BuildContext context,
    bool isLoading,
    List<MovementModel> movementList,
    MovementPdfFormModel form,
  ) {
    return DrawerBox(
      header: Column(
        children: [
          const Text(
            'Reporte de movimiento al inventario',
            style: Typo.titleDark,
          ),
          Visibility(
            visible: isLoading,
            replacement: const SizedBox(
              height: 4,
            ),
            child: const LinearProgressIndicatorAxol(),
          ),
        ],
      ),
      actions: [
        SecondaryButtonDialog(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        const Divider(
          color: ColorPalette.lightItems20,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                      const Text(
                        'Pantalla actual',
                        style: Typo.boldLabelDark,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 120,
                        child: SecondaryButtonDialog(
                          text: 'Descargar',
                          textStyle: Typo.labelDark,
                          border: const BorderSide(
                              color: ColorPalette.lightItems10),
                          icon: const Icon(
                            Icons.download,
                            color: ColorPalette.lightItems10,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<MovementPdfCubit>()
                                      .downloadPdf(movementList);
                                },
                        ),
                      ),
                    ],
                  )),
              const Expanded(
                  flex: 2,
                  child: Text(
                    'Descarga archivo PDF con los movimientos que se muestra en la pantalla actual de la lista de movimientos al inventario.',
                    style: Typo.smallLabelDark,
                  )),
            ],
          ),
        ),
        const Divider(
          color: ColorPalette.lightItems20,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                    const Text('Descarga por filtro',
                        style: Typo.boldLabelDark),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 120,
                      child: SecondaryButtonDialog(
                        text: 'Descargar',
                        textStyle: Typo.labelDark,
                        border:
                            const BorderSide(color: ColorPalette.lightItems10),
                        icon: const Icon(
                          Icons.download,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                context
                                    .read<MovementPdfCubit>()
                                    .downloadPdfFilter(
                                      form.document.text,
                                      form.folio.text,
                                    );
                              },
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
                      const Text(
                        'Documento',
                        style: Typo.labelDark,
                      ),
                      TextField(
                        controller: form.document,
                        enabled: !isLoading,
                        style: Typo.bodyDark,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ColorPalette.filled,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorPalette.lightItems10),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(40)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette.primary),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Filtra movimientos al inventario por documento. Separe por comas si quiere agregar más de un documento.',
                        style: Typo.smallLabelDark,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Folio',
                        style: Typo.labelDark,
                      ),
                      TextField(
                        controller: form.folio,
                        enabled: !isLoading,
                        style: Typo.bodyDark,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ColorPalette.filled,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorPalette.lightItems10),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(40)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette.primary),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Filtra movimientos al inventario por número de folio. Separe por comas si quiere agregar más de un número de folio.',
                        style: Typo.smallLabelDark,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        const Divider(
          color: ColorPalette.lightItems20,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
