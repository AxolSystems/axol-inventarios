import 'package:axol_inventarios/modules/inventory_/movements/cubit/movement_pdf/movement_file_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/movement_pdf/movement_file_cubit.dart';
import '../model/movement_model.dart';
import '../model/movement_pdf_form_model.dart';

class MovementDrawerFile extends StatelessWidget {
  final List<MovementModel> movementList;
  const MovementDrawerFile({super.key, required this.movementList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovementFileCubit()),
        BlocProvider(create: (_) => MovementFileForm()),
      ],
      child: MovementDrawerFileBuild(movementList: movementList),
    );
  }
}

class MovementDrawerFileBuild extends StatelessWidget {
  final List<MovementModel> movementList;
  const MovementDrawerFileBuild({super.key, required this.movementList});

  @override
  Widget build(BuildContext context) {
    MovementFileFormModel form = context.read<MovementFileForm>().state;
    return BlocConsumer(
      bloc: context.read<MovementFileCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingMoveFileState) {
          return movementDrawerFile(context, true, [], form);
        } else if (state is LoadedMoveFileState) {
          return movementDrawerFile(context, false, movementList, form);
        } else {
          return movementDrawerFile(context, false, [], form);
        }
      },
      listener: (context, state) {
        if (state is ErrorMoveFileState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget movementDrawerFile(
    BuildContext context,
    bool isLoading,
    List<MovementModel> movementList,
    MovementFileFormModel form,
  ) {
    final widthScreen = MediaQuery.of(context).size.width;
    List<DropdownMenuItem<int>> items = [
      const DropdownMenuItem(value: -2, child: Text('TODOS'))
    ];
    DropdownMenuItem<int> item;

    for (var warehouse in form.warehouseList) {
      item = DropdownMenuItem(
        value: warehouse.id,
        child: Text('${warehouse.id} - ${warehouse.name}'),
      );
      items.add(item);
    }

    return DrawerBox(
      width: widthScreen >= 600 ? 0.5 : 0.95,
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
                        width: widthScreen >= 600 ? 120 : 56,
                        child: SecondaryButtonDialog(
                          text: widthScreen >= 600 ? 'Descargar' : '',
                          textStyle: Typo.systemDark,
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
                                      .read<MovementFileCubit>()
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
                    const Text('Descarga por folio', style: Typo.boldLabelDark),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: widthScreen >= 600 ? 120 : 56,
                      child: SecondaryButtonDialog(
                        text: widthScreen >= 600 ? 'Descargar' : '',
                        textStyle: Typo.systemDark,
                        border:
                            const BorderSide(color: ColorPalette.lightItems10),
                        icon: const Icon(
                          Icons.download,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                final int folio =
                                    int.tryParse(form.folio.text) ?? -1;
                                if (folio < 0) {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AlertDialogAxol(
                                              text: 'Agrege folio existente'));
                                } else {
                                  context
                                      .read<MovementFileCubit>()
                                      .downloadPdfFolio(folio);
                                }
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
                        'Folio',
                        style: Typo.systemDark,
                      ),
                      TextField(
                        controller: form.folio,
                        enabled: !isLoading,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
                        ],
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
                      const SizedBox(height: 4),
                      const Text(
                        'Filtra movimientos al inventario por número de folio.',
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
                    const Text('Descarga por documento',
                        style: Typo.boldLabelDark),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: widthScreen >= 600 ? 120 : 56,
                      child: SecondaryButtonDialog(
                        text: widthScreen >= 600 ? 'Descargar' : '',
                        textStyle: Typo.systemDark,
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
                                    .read<MovementFileCubit>()
                                    .downloadPdfDocument(
                                      document: form.document.text,
                                      concept: form.concept.text,
                                      isFilterTime: form.filterDate,
                                      startTime: form.startTime,
                                      endTime: form.endTime,
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
                        style: Typo.systemDark,
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
                      const SizedBox(height: 4),
                      const Text(
                        'Filtra movimientos al inventario por documento.',
                        style: Typo.smallLabelDark,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Concepto',
                        style: Typo.systemDark,
                      ),
                      TextField(
                        controller: form.concept,
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
                      const SizedBox(height: 4),
                      const Text(
                        'Filtra movimientos al inventario por número de concepto. Separe por comas si quiere agregar más de un concepto.',
                        style: Typo.smallLabelDark,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                activeColor: ColorPalette.primary,
                                value: form.filterDate,
                                onChanged: (value) {
                                  form.filterDate = value;
                                  context.read<MovementFileCubit>().load();
                                },
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Filtrar fecha', style: Typo.systemDark),
                                SizedBox(height: 4),
                                Text(
                                  'Filtra las fechas que se encuentren dentro del rango indicado por Fecha Inicial y Fecha Final',
                                  style: Typo.smallLabelDark,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Fecha inicial',
                        style: Typo.systemDark,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.filled,
                              border:
                                  Border.all(color: ColorPalette.lightItems10),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(FormatDate.dmy(form.startTime),
                                      style: Typo.bodyDark),
                                )),
                                IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: form.startTime,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      if (value != null) {
                                        form.startTime =
                                            FormatDate.startDay(value);
                                        context
                                            .read<MovementFileCubit>()
                                            .load();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: ColorPalette.lightItems10,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Fecha final',
                        style: Typo.systemDark,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.filled,
                              border:
                                  Border.all(color: ColorPalette.lightItems10),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(FormatDate.dmy(form.endTime),
                                      style: Typo.bodyDark),
                                )),
                                IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: form.endTime,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      if (value != null) {
                                        form.endTime = FormatDate.endDay(value);
                                        context
                                            .read<MovementFileCubit>()
                                            .load();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: ColorPalette.lightItems10,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
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
                    const Text('Movimientos al inventario',
                        style: Typo.boldLabelDark),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: widthScreen >= 600 ? 80 : 56,
                      child: SecondaryButtonDialog(
                        text: widthScreen >= 600 ? 'CSV' : '',
                        textStyle: Typo.systemDark,
                        border:
                            const BorderSide(color: ColorPalette.lightItems10),
                        icon: const Icon(
                          Icons.download,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: isLoading ? null : () {
                          context.read<MovementFileCubit>().csvMove(form);
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
                        'Almacén',
                        style: Typo.systemDark,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          filled: true,
                          fillColor: ColorPalette.filled,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: ColorPalette.lightItems10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: ColorPalette.primary),
                          ),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(40)),
                        ),
                        items: items,
                        value: form.warehouseSelect,
                        style: Typo.bodyDark,
                        onChanged: (value) {
                          if (value != null) {
                            form.warehouseSelect = value;
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seleccione el almacén del que se requiere tomar los datos.',
                        style: Typo.smallLabelDark,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                activeColor: ColorPalette.primary,
                                value: form.input,
                                onChanged: (value) {
                                  form.input = value;
                                  context.read<MovementFileCubit>().load();
                                },
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Entradas', style: Typo.systemDark),
                                SizedBox(height: 4),
                                Text(
                                  'Toma los movimientos que son entradas al inventario.',
                                  style: Typo.smallLabelDark,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                activeColor: ColorPalette.primary,
                                value: form.output,
                                onChanged: (value) {
                                  form.output = value;
                                  context.read<MovementFileCubit>().load();
                                },
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Salidas', style: Typo.systemDark),
                                SizedBox(height: 4),
                                Text(
                                  'Toma los movimientos que son salidas al inventario',
                                  style: Typo.smallLabelDark,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      const Text(
                        'Fecha inicial',
                        style: Typo.systemDark,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.filled,
                              border:
                                  Border.all(color: ColorPalette.lightItems10),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(
                                      FormatDate.dmy(form.startTimeMoves),
                                      style: Typo.bodyDark),
                                )),
                                IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: form.startTimeMoves,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      if (value != null) {
                                        form.startTimeMoves =
                                            FormatDate.startDay(value);
                                        context
                                            .read<MovementFileCubit>()
                                            .load();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: ColorPalette.lightItems10,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Fecha final',
                        style: Typo.systemDark,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.filled,
                              border:
                                  Border.all(color: ColorPalette.lightItems10),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(FormatDate.dmy(form.endTimeMoves),
                                      style: Typo.bodyDark),
                                )),
                                IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: form.endTimeMoves,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      if (value != null) {
                                        form.endTimeMoves =
                                            FormatDate.endDay(value);
                                        context
                                            .read<MovementFileCubit>()
                                            .load();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    color: ColorPalette.lightItems10,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
