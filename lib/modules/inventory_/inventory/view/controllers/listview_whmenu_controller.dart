import 'package:axol_inventarios/modules/inventory_/inventory/cubit/warehouse_stream_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/toolbar.dart';
import '../../../../../models/elemnets_bar_model.dart';
import '../../cubit/warehouse_setting/warehouse_setting_cubit.dart';
import '../../cubit/warehouses_load/warehouses_load_cubit.dart';
import '../../cubit/warehouses_load/wareshouses_load_state.dart';
import '../widgets/warehouse_menu/listview_warehouse_menu.dart';
import 'drawer_warehouse_controller.dart';

/*class ListviewWHMenuController extends StatelessWidget {
  const ListviewWHMenuController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehousesLoadCubit, WarehousesLoadState>(
      bloc: BlocProvider.of<WarehousesLoadCubit>(context)..loadWarehouses(0),
      builder: (context, state) {
        if (state is LoadingState) {
          return const Column(
            children: [
              SizedBox(height: 4,),
              LinearProgressIndicator(),
              Expanded(child: SizedBox())
            ],
          );
        } else if (state is LoadedState) {
          Color? colorEdit;
          Color? colorDelete;
          if (state.mode == 1) {
            colorEdit = Colors.white;
          } else if (state.mode == 2) {
            colorDelete = Colors.white;
          }
          return Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListviewWarehouseMenu(
                    listData: state.warehouses,
                    users: state.users,
                    mode: state.mode,
                  ),
                ),
              ),
              Toolbar(
                listData: [
                  ElementsBarModel(
                      text: null,
                      icon: const Icon(Icons.add),
                      action: () {
                        showDialog(
                            context: context,
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(create: (_) => WarehouseSettingCubit()),
                                BlocProvider(create: (_) => WarehouseStreamCubit()),
                              ],
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      color: Colors.black26,
                                    )),
                                    DrawerWarehouseController(
                                      settingMode: 0,
                                      users: state.users,
                                      widthDrawer: 500,
                                    ),
                                  ],
                                ))).then((value) {
                          context.read<WarehousesLoadCubit>().loadWarehouses(0);
                        });
                      }),
                  ElementsBarModel(
                    text: null,
                    icon: const Icon(Icons.edit_square),
                    action: () {
                      if (state.mode == 1) {
                        context
                            .read<WarehousesLoadCubit>()
                            .reload(0, state.users, state.warehouses);
                      } else {
                        context
                            .read<WarehousesLoadCubit>()
                            .reload(1, state.users, state.warehouses);
                      }
                    },
                    secondaryColor: colorEdit,
                  ),
                  ElementsBarModel(
                    text: null,
                    icon: const Icon(Icons.delete),
                    action: () {
                      if (state.mode == 2) {
                        context
                            .read<WarehousesLoadCubit>()
                            .reload(0, state.users, state.warehouses);
                      } else {
                        context
                            .read<WarehousesLoadCubit>()
                            .reload(2, state.users, state.warehouses);
                      }
                    },
                    secondaryColor: colorDelete,
                  ),
                  ElementsBarModel(
                    icon: const Icon(Icons.refresh),
                    action: () {
                      context.read<WarehousesLoadCubit>().loadWarehouses(0);
                    },
                  ),
                ],
              ),
            ],
          );
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
