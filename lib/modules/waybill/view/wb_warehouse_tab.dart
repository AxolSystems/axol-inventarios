import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/wb_warehouse/wb_warehouse_cubit.dart';
import '../cubit/wb_warehouse/wb_warehouse_state.dart';
import 'wb_add_list.dart';

class WbWarehouseTab extends StatelessWidget {
  const WbWarehouseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WbWarehouseTabCubit(),
        )
      ],
      child: const WbWarehouseTabBuild(),
    );
  }
}

class WbWarehouseTabBuild extends StatelessWidget {
  const WbWarehouseTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WbWarehouseTabCubit, WbWarehouseTabState>(
      bloc: context.read<WbWarehouseTabCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingWbWarehouseTabState) {
          return wbWarehouseTab(context, true, []);
        } else if (state is LoadedWbWarehouseTabState) {
          return wbWarehouseTab(context, false, state.warehouseList);
        } else {
          return wbWarehouseTab(context, false, []);
        }
      },
      listener: (context, state) {
        if (state is ErrorWbWarehouseTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget wbWarehouseTab(BuildContext context, bool isLoading,
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
                    bottom: BorderSide(color: ColorPalette.darkItems20),
                  ),
                ),
                child: ButtonRowTable(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WbAddList(warehouse: warehouse),
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
