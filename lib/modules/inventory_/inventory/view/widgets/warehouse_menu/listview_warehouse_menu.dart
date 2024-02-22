import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/cubit/warehouse_stream_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../user/model/user_mdoel.dart';
import '../../../../../../utilities/theme/theme.dart';
import '../../../cubit/warehouse_setting/warehouse_setting_cubit.dart';
import '../../../cubit/warehouses_load/warehouses_load_cubit.dart';
import '../../controllers/drawer_warehouse_controller.dart';
import '../../views/warehouse_view.dart';

class ListviewWarehouseMenu extends StatelessWidget {
  final List<WarehouseModel> listData;
  final List<UserModel> users;
  final int mode;

  const ListviewWarehouseMenu(
      {super.key,
      required this.listData,
      required this.users,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    Icon? icon;
    if (mode == 0) {
      //Navigate mode
      icon = const Icon(Icons.navigate_next, color: ColorPalette.lightText);
    } else if (mode == 1) {
      //Edit mode
      icon = const Icon(Icons.edit, color: ColorPalette.lightText);
    } else if (mode == 2) {
      //Delete mode
      icon =
          const Icon(Icons.highlight_remove, color: ColorPalette.lightText);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listData.length,
      itemBuilder: ((context, index) {
        final elementList = listData[index];
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white12),
            ),
          ),
          child: SizedBox(
            height: 50,
            width: 300,
            child: OutlinedButton(
                onPressed: () {
                  if (mode == 0) {
                    //Navigate mode
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WarehouseView(
                                  warehouse: elementList,
                                  warehouseList: listData,
                                )));
                  } else if (mode == 1) {
                    //Edit mode
                    showDialog(
                        context: context,
                        builder: (context) {
                          WarehouseStreamModel warehouseStream =
                              WarehouseStreamModel(
                                  textfieldId: WHTextfieldModel(
                                    position: 0,
                                    text: elementList.id.toString(),
                                    validation: ValidationFormModel.trueValid(),
                                  ),
                                  textfieldName: WHTextfieldModel(
                                    position: 0,
                                    text: elementList.name.toString(),
                                    validation: ValidationFormModel.trueValid(),
                                  ),
                                  dropdownManager: WHDropdownModel(
                                    value: elementList.retailManager,
                                    validation: ValidationFormModel.trueValid(),
                                  ));
                          return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (_) => WarehouseSettingCubit()),
                                BlocProvider(
                                    create: (_) => WarehouseStreamCubit(
                                        warehouseStream: warehouseStream)),
                              ],
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    color: Colors.black26,
                                  )),
                                  DrawerWarehouseController(
                                    settingMode: 1,
                                    users: users,
                                    widthDrawer: 500,
                                    currentWarehouse: elementList,
                                  ),
                                ],
                              ));
                        }).then((value) {
                      context.read<WarehousesLoadCubit>().loadWarehouses(0);
                    });
                  } else if (mode == 2) {
                    //Delete mode
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                          create: (_) => WarehouseSettingCubit(),
                          child: DrawerWarehouseController(
                            settingMode: 3,
                            users: users,
                            widthDrawer: 0,
                            currentWarehouse: elementList,
                          )),
                    ).then((value) {
                      context.read<WarehousesLoadCubit>().loadWarehouses(0);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(elementList.name, style: Typo.bodyText5),
                    icon!,
                  ],
                )),
          ),
        );
      }),
    );
  }
}

class CallRemove {
  void call(BuildContext context, WarehouseModel elementList) {
    context.read<WarehouseSettingCubit>().remove(elementList.id);
  }
}
