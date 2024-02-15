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
    return movementDrawerFilter(context);
  }

  Widget movementDrawerFilter(BuildContext context) {
    return DrawerBox(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        header: const Text(
          'Filtros',
          style: Typo.subtitleDark,
        ),
        actions: [
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          
          const DropdownMenu(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.lightItems),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.primary),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              
            ),
            selectedTrailingIcon: Icon(Icons.arrow_drop_down, color: ColorPalette.primary,),

            width: 200,
            label: Text(
              'Almacén',
              style: Typo.smallLabelLight,
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 0, label: 'A'),
              DropdownMenuEntry(value: 1, label: 'B')
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Fecha inicial',
            style: Typo.smallLabelLight,
          ),
          Row(
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.lightItems),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                        child: Center(
                      child: Text('00/00/00', style: Typo.labeldark),
                    )),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.calendar_month,
                        color: ColorPalette.lightItems,
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Fecha final',
            style: Typo.smallLabelLight,
          ),
          Row(
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.lightItems),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                        child: Center(
                      child: Text('00/00/00', style: Typo.labeldark),
                    )),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.calendar_month,
                        color: ColorPalette.lightItems,
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ]);
  }
}
