import 'package:axol_inventarios/modules/inventory_/inventory/cubit/inventory_movements/moves_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/widgets/appbar_axol.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/inventory_load/inventory_load_cubit.dart';
import '../../cubit/inventory_movements/inventory_moves_cubit.dart';
import '../../cubit/inventory_movements/inventory_moves_state.dart';
import '../../cubit/transfer_cubit.dart';
import '../../cubit/textfield_finder_invrow_cubit.dart';
import '../widgets/inventory_movement/page_invmov.dart';
import 'warehouse_view.dart';

class InventoryMovementView extends StatelessWidget {
  final WarehouseModel warehouse;
  final List<WarehouseModel> warehouseList;

  const InventoryMovementView(
      {super.key, required this.warehouse, required this.warehouseList});

  @override
  Widget build(BuildContext context) {
    final String title = 'Movimientos en almacén: ${warehouse.name}';

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => InventoryMovesCubit()),
          BlocProvider(create: (_) => InventoryLoadCubit()),
          BlocProvider(create: (_) => TextfieldFinderInvrowCubit()),
          BlocProvider(create: (_) => TransferCubit()),
          BlocProvider(create: (_) => MovesFormCubit()),
        ],
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: ColorPalette.darkBackground,
            appBar: AppBarAxol(title: title).appBarAxol(),
            body: BlocConsumer<InventoryMovesCubit, InventoryMovesState>(
              bloc: context.read<InventoryMovesCubit>()..initLoad(),
              listener: (context, state) {
                if (state is SaveLoadedState) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WarehouseView(
                                warehouse: warehouse,
                                warehouseList: warehouseList,
                              )));
                } else if (state is SaveErrorState) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Alerta!'),
                      content: Text(state.errorMessage),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Aceptar'),
                        )
                      ],
                    ),
                  );
                }
                if (state is ErrorState) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Alerta!'),
                      content: Text(
                        'Error: $state',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Aceptar'),
                        )
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoadedState) {
                  context.read<MovesFormCubit>().setForm(state.form);
                  return PageInvMov(
                    warehouse: warehouse,
                    warehouseList: warehouseList,
                  );
                } else if (state is SaveLoadingState) {
                  return const LinearProgressIndicator();
                } else if (state is SaveErrorState) {
                  return PageInvMov(
                    warehouse: warehouse,
                    warehouseList: warehouseList,
                  );
                } else {
                  return PageInvMov(
                    warehouse: warehouse,
                    warehouseList: warehouseList,
                  );
                }
              },
            ),
          ),
          //InventoryMovesController(inventoryName: inventoryName),
        ));
  }
}
