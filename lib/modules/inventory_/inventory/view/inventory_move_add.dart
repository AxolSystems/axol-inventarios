import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/navigation_utilities.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/appbar_axol.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../cubit/inventory_move/inventory_move_cubit.dart';
import '../cubit/inventory_move/inventory_move_state.dart';
import '../model/inventory_move/inventory_move_model.dart';

class InventoryMoveAdd extends StatelessWidget {
  const InventoryMoveAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryMoveCubit()),
        BlocProvider(create: (_) => InventoryMoveForm()),
      ],
      child: InventoryMoveAddBuild(),
    );
  }
}

class InventoryMoveAddBuild extends StatelessWidget {
  const InventoryMoveAddBuild({super.key});

  @override
  Widget build(BuildContext context) {
    InventoryMoveModel form = context.read<InventoryMoveForm>().state;
    return BlocConsumer<InventoryMoveCubit, InventoryMoveState>(
      bloc: context.read<InventoryMoveCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingInventoryMoveState) {
          return inventoryMoveAdd(context, true, form);
        } else if (state is LoadedInventoryMoveState) {
          return inventoryMoveAdd(context, false, form);
        } else {
          return inventoryMoveAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorInventoryMoveState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget inventoryMoveAdd(
      BuildContext context, bool isLoading, InventoryMoveModel form) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol(
        title: 'Movimiento al inventario',
        isLoading: isLoading,
      ).appBarAxol(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationUtilities.emptyNavRailReturn(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: ColorPalette.darkItems)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        DropdownMenu(
                          width: 200,
                          //controller: form.tfWarehose.controller,
                          enabled: !isLoading,
                          textStyle: Typo.labelLight,
                          label: const Text(
                            'Concepto',
                            style: Typo.labelLight,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            isDense: true,
                            constraints:
                                BoxConstraints.tight(const Size.fromHeight(34)),
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
                          trailingIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.lightItems10,
                            size: 20,
                          ),
                          dropdownMenuEntries: [],
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            style: Typo.labelLight,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              labelText: 'Documento',
                              labelStyle: Typo.labelLight,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPalette.lightItems10),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          FormatDate.dmy(form.date),
                          style: Typo.labelLight,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Almacén: ',
                          style: Typo.labelLight,
                        ),
                      ],
                    ),
                  ),
                  HeaderTable(dataList: [
                    DataTableAxol.text('Clave'),
                    DataTableAxol.text('Descripción'),
                    DataTableAxol.text('Cantidad'),
                    DataTableAxol.text('Peso unitario'),
                    DataTableAxol.text('Peso total'),
                    DataTableAxol.text('Opciones'),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
