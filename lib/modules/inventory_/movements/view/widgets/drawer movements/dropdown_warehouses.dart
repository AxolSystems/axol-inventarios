import 'package:axol_inventarios/modules/inventory_/movements/model/movement_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inventory/model/warehouse_model.dart';
import '../../../cubit/movement_filters/movement_filters_cubit.dart';

/*class DropdownWarehouses extends StatelessWidget {
  final MovementFilterModel filters;
  final int mode;

  const DropdownWarehouses(
      {super.key, required this.filters, required this.mode});

  @override
  Widget build(BuildContext context) {
    final WarehouseModel warehouseValue;
    final int i;
    /*if (mode == 1 && filters.warehousesList.last.id == 'all') {
      filters.warehousesList.removeLast();
      if (filters.warehouse.id == 'all') {
        warehouseValue = filters.warehousesList.first;
      } else {
        warehouseValue = filters.warehouse;
      }
    } else {
      
    }*/
    if (filters.warehousesList.contains(filters.warehouse)) {
      warehouseValue = filters.warehouse;
    } else {
      i = filters.warehousesList
          .indexWhere((element) => element.name == filters.warehouse.name);
      if (i > -1) {
        warehouseValue = filters.warehousesList.elementAt(i);
      } else {
        warehouseValue = filters.warehousesList.last;
      }
    }
    return SizedBox(
      width: 250,
      height: 40,
      child: DropdownButton<WarehouseModel>(
        isExpanded: true,
        value: warehouseValue,
        items: filters.warehousesList.map((e) {
          return DropdownMenuItem(value: e, child: Text(e.name));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            context
                .read<MovementFiltersCubit>()
                .changeWarehouse(filters, value);
          }
        },
      ),
    );
  }
}*/
