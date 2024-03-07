import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/inventory_load/inventory_load_cubit.dart';
import '../../cubit/inventory_load/inventory_load_state.dart';
import '../widgets/warehouse/table_warehouse.dart';

/*class TableWarehouseController extends StatelessWidget {
  const TableWarehouseController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryLoadCubit, InventoryLoadState>(
      bloc: BlocProvider.of<InventoryLoadCubit>(context)..loadInventory('', ''),
      builder: (context, state) {
        if (state is LoadingState) {
          return const LinearProgressIndicator();
        } else if (state is LoadedInventory) {
          return TableWarehouse(listData: state.inventoryList);
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return const Text(
            'Error de estado.',
            style: TextStyle(color: Colors.red),
          );
        }
      },
    );
  }
}*/
