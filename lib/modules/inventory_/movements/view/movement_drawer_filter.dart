import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/shimmer_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../cubit/movement_filter/movement_filter_cubit.dart';
import '../cubit/movement_filter/movement_filter_form.dart';
import '../cubit/movement_filter/movement_filter_state.dart';
import '../model/movement_filter_form_model.dart';
import '../model/movement_filter_model.dart';

class MovementDrawerFilter extends StatelessWidget {
  final Map filter;
  const MovementDrawerFilter({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovementFilterCubit()),
        BlocProvider(create: (_) => MovementFilterForm()),
      ],
      child: MovementDrawerFilterBuild(filterMap: filter),
    );
  }
}

class MovementDrawerFilterBuild extends StatelessWidget {
  final Map filterMap;
  const MovementDrawerFilterBuild({super.key, required this.filterMap});

  @override
  Widget build(BuildContext context) {
    MovementFilterFormModel form = context.read<MovementFilterForm>().state;
    MovementFilterModel filter = MovementFilterModel.mapToFilter(filterMap);
    return BlocConsumer<MovementFilterCubit, MovementFilterState>(
      bloc: context.read<MovementFilterCubit>()..initLoad(form, filter),
      builder: (context, state) {
        if (state is LoadingMovementFilterState) {
          return movementDrawerFilter(context, true, form);
        } else if (state is LoadedMovementFilterState) {
          return movementDrawerFilter(context, false, form);
        } else {
          return movementDrawerFilter(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorMovementFilterState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget movementDrawerFilter(
      BuildContext context, bool isLoading, MovementFilterFormModel form) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double elementWidth = ((screenWidth * 0.5) * (2 / 3)) - 16;
    List<DropdownMenuEntry<int>> entryList = [];
    DropdownMenuEntry<int> entry;

    /*for (int i = 0; i < form.warehouseList.length; i++) {
      entry = DropdownMenuEntry(value: i, label: form.warehouseList[i].name);
      entryList.add(entry);
    }*/

    for (var warehouse in form.warehouseList) {
      entry = DropdownMenuEntry(value: warehouse.id, label: warehouse.name);
      entryList.add(entry);
    }

    return DrawerBox(
        header: const Text(
          'Filtros',
          style: Typo.titleDark,
        ),
        actions: [
          PrimaryButtonDialog(
            text: 'Aceptar',
            onPressed: () {},
          ),
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          const Visibility(
            visible: false,
            replacement: SizedBox(height: 4),
            child: LinearProgressIndicatorAxol(),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: ColorPalette.lightItems20),
                bottom: BorderSide(color: ColorPalette.lightItems20),
              ),
            ),
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Almacén',
                          style: Typo.boldLabelDark,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nombre', style: Typo.labelDark),
                        isLoading ? ShimmerIndicator.horizontalExpanded(height: 30):
                        DropdownMenu(
                          width: elementWidth,
                          controller: form.tfWarehose.controller,
                          enabled: !isLoading,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            isDense: true,
                            constraints:
                                BoxConstraints.tight(const Size.fromHeight(40)),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.lightItems10),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.primary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          selectedTrailingIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          dropdownMenuEntries: entryList,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 230,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorPalette.lightItems20))),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha',
                          style: Typo.boldLabelDark,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                    context.read<MovementFilterCubit>().load();
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
                                  Text('Filtrar fecha', style: Typo.labelDark),
                                  SizedBox(height: 8),
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
                          style: Typo.labelDark,
                        ),
                        Row(
                          children: [
                            Container(
                              width: elementWidth,
                              decoration: BoxDecoration(
                                color: ColorPalette.filled,
                                border: Border.all(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                      child: Center(
                                    child:
                                        Text('00/00/00', style: Typo.bodyDark),
                                  )),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.calendar_month,
                                      color: ColorPalette.lightItems10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Fecha final',
                          style: Typo.labelDark,
                        ),
                        Row(
                          children: [
                            Container(
                              width: elementWidth,
                              decoration: BoxDecoration(
                                color: ColorPalette.filled,
                                border: Border.all(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                      child: Center(
                                    child:
                                        Text('00/00/00', style: Typo.bodyDark),
                                  )),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.calendar_month,
                                      color: ColorPalette.lightItems10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
