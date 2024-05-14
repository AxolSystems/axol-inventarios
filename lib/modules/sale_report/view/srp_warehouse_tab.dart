import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/add/srp_add_state.dart';
import '../cubit/warehouses_tab/srp_warehouse_tab_cubit.dart';
import '../cubit/warehouses_tab/srp_warehouse_tab_state.dart';
import 'salereport_add.dart';

class SrpWarehouseTab extends StatelessWidget {
  const SrpWarehouseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpWarehouseTabCubit()),
      ],
      child: const SrpWarehouseTabBuild(),
    );
  }
}

class SrpWarehouseTabBuild extends StatelessWidget {
  const SrpWarehouseTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SrpWarehouseTabCubit, SrpWarehouseTabState>(
      bloc: context.read<SrpWarehouseTabCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingSrpWarehouseTabState) {
          return srpWarehouseTab(context, true, []);
        } else if (state is LoadedSrpWarehouseTabState) {
          return srpWarehouseTab(context, false, state.warehouseList);
        } else {
          return srpWarehouseTab(context, false, []);
        }
      },
      listener: (context, state) {
        if (state is ErrorSrpWarehouseTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget srpWarehouseTab(BuildContext context, bool isLoading,
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
                        builder: (BuildContext context) => SaleReportAdd(warehouse: warehouse, subState: SrpAddSubState.add),
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
