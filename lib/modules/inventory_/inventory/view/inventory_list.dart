import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/utilities/navigation_utilities.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../cubit/inventory_list/inventory_list_cubit.dart';
import '../cubit/inventory_list/inventory_list_state.dart';

class InventoryList extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryList({
    super.key,
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryListCubit()),
        BlocProvider(create: (_) => TableViewFormCubit()),
      ],
      child: InventoryListBuild(warehouse: warehouse),
    );
  }
}

class InventoryListBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryListBuild({
    super.key,
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<TableViewFormCubit>().state;
    return BlocConsumer<InventoryListCubit, InventoryListState>(
      bloc: context.read<InventoryListCubit>()..initLoad(warehouse),
      builder: (context, state) {
        if (state is LoadingInventoryListState) {
          return inventoryList(context, true, []);
        } else if (state is LoadedInventoryListState) {
          return inventoryList(context, false, state.inventoryRowList);
        } else {
          return inventoryList(context, false, []);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget inventoryList(BuildContext context, bool isLoading,
      List<InventoryRowModel> inventoryRowList) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol(
        title: 'Inventario',
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
                HeaderTable(
                  dataList: [
                    DataTableAxol.text('Clave'),
                    DataTableAxol(
                      text: 'Descripción',
                      flex: 3,
                    ),
                    DataTableAxol.text('Stock'),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: inventoryRowList.length,
                  itemBuilder: (context, index) {
                    final inventoryRow = inventoryRowList[index];

                    return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: ColorPalette.darkItems)),
                        ),
                        child: ButtonRowTable(
                            child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  inventoryRow.product.code,
                                  style: Typo.bodyLight,
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  inventoryRow.product.description,
                                  style: Typo.bodyLight,
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                              flex: 1,
                              child: Text(
                                inventoryRow.stock.toString(),
                                style: Typo.bodyLight,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )));
                  },
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
