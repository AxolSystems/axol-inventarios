import 'package:axol_inventarios/modules/inventory_/inventory/cubit/warehouse_tab/warehouse_tab_state.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/warehouse_tab/warehouse_tab_cubit.dart';
import '../model/warehouse_model.dart';
import 'inventory_list.dart';

class WarehouseTab extends StatelessWidget {
  const WarehouseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WarehouseTabCubit(),
        )
      ],
      child: const WarehouseTabBuild(),
    );
  }
}

class WarehouseTabBuild extends StatelessWidget {
  const WarehouseTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WarehouseTabCubit, WarehouseTabState>(
      bloc: context.read<WarehouseTabCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingWarehouseTabState) {
          return warehouseTab(context, true, []);
        } else if (state is LoadedWarehouseTabState) {
          return warehouseTab(context, false, state.warehouseList);
        } else {
          return warehouseTab(context, false, []);
        }
      },
      listener: (context, state) {
        if (state is ErrorWarehouseTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget warehouseTab(BuildContext context, bool isLoading,
      List<WarehouseModel> warehouseList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: isLoading,
          replacement: Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: warehouseList.length,
            itemBuilder: (context, index) {
              final warehouse = warehouseList[index];

              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorPalette.darkItems),
                  ),
                ),
                child: ButtonRowTable(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => InventoryList(warehouse: warehouse),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        warehouse.name,
                        style: Typo.subtitleLight,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: ColorPalette.lightBackground,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          child: const LinearProgressIndicatorAxol(),
        )
      ],
    );
  }
}
