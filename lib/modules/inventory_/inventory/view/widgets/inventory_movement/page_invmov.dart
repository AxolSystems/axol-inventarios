import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../global_widgets/toolbar.dart';
import '../../../../../../global_widgets/views_bar.dart';
import '../../../../../../models/elemnets_bar_model.dart';
import '../../../cubit/inventory_movements/moves_form_cubit.dart';
import '../../../model/inventory_move/inventory_move_model.dart';
import '../../../cubit/inventory_movements/inventory_moves_cubit.dart';
import '../../../model/inventory_move/inventory_move_row_model.dart';
import 'listview_inventory_movement.dart';

class PageInvMov extends StatelessWidget {
  final WarehouseModel warehouse;
  final List<WarehouseModel> warehouseList;

  const PageInvMov(
      {super.key, required this.warehouse, required this.warehouseList});

  @override
  Widget build(BuildContext context) {
    InventoryMoveModel form = context.read<MovesFormCubit>().state;
    List<InventoryMoveRowModel> products = [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewsBar(
          listData: [
            ElementsBarModel(
                icon: const Icon(Icons.arrow_back),
                text: 'Regresar',
                action: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        Expanded(
          child: ListviewInventoryMovement(
            warehouse: warehouse,
            warehouseList: warehouseList,
          ),
        ),
        Toolbar(
          listData: [
            ElementsBarModel(
              text: null,
              icon: const Icon(Icons.add),
              action: () {
                products = form.moveList;
                products.add(InventoryMoveRowModel.empty());
                form.moveList = products;
                context.read<MovesFormCubit>().setProducts(products);
                context.read<InventoryMovesCubit>().load(form);
              },
            ),
            ElementsBarModel(
              text: null,
              icon: const Icon(Icons.save),
              action: () {
                context
                    .read<InventoryMovesCubit>()
                    .saveMovements(form, warehouse);
              },
            )
          ],
        ),
      ],
    );
  }
}
