import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';

class MovementDrawerFilter extends StatelessWidget {
  const MovementDrawerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: const [],
      child: const MovementDrawerFilterBuild(),
    );
  }
}

class MovementDrawerFilterBuild extends StatelessWidget {
  const MovementDrawerFilterBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return movementDrawerFilter(context, false);
  }

  Widget movementDrawerFilter(BuildContext context, bool isLoading) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double elementWidth = ((screenWidth * 0.5) * (2 / 3)) - 16;
    return DrawerBox(
        header: const Text(
          'Filtros',
          style: Typo.titleDark,
        ),
        actions: [
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          Visibility(
            visible: isLoading,
            replacement: const SizedBox(height: 4),
            child: const LinearProgressIndicatorAxol(),
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
                        const Text('Nombre', style: Typo.labeldark),
                        DropdownMenu(
                          width: elementWidth,
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
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 0, label: 'A'),
                            DropdownMenuEntry(value: 1, label: 'B')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 155,
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
                        const Text(
                          'Fecha inicial',
                          style: Typo.labeldark,
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
                          style: Typo.labeldark,
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
