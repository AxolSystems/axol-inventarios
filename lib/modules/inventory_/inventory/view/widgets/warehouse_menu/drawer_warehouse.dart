import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/textfield_model.dart';
import '../../../../../user/model/user_mdoel.dart';
import '../../../model/warehouse_model.dart';
import '../../../cubit/warehouse_setting/warehouse_setting_cubit.dart';
import '../../../cubit/warehouse_stream_cubit.dart';

class DrawerWarehouse extends StatelessWidget {
  final List<UserModel> users;
  final int settingMode;
  final WarehouseModel? currentWarehouse;
  final double widthDrawer;

  const DrawerWarehouse({
    super.key,
    required this.users,
    required this.settingMode,
    this.currentWarehouse,
    required this.widthDrawer,
  });

  @override
  Widget build(BuildContext context) {
    WarehouseStreamModel warehouseStream =
        context.read<WarehouseStreamCubit>().state;
    TextEditingController textController = TextEditingController();
    TextEditingController textController2 = TextEditingController();
    textController.value = TextEditingValue(
        text: warehouseStream.textfieldName.text,
        selection: TextSelection.collapsed(
            offset: warehouseStream.textfieldName.position));
    textController2.value = TextEditingValue(
      text: warehouseStream.textfieldId.text,
      selection:
          TextSelection.collapsed(offset: warehouseStream.textfieldId.position),
    );
    return Drawer(
      width: widthDrawer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          const Center(
            child: Text('Titulo de drawer'),
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Número de almacén:'),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: TextField(
                        enabled: settingMode == 1 ? false : true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          errorStyle: const TextStyle(height: 0.3),
                          errorText:
                              warehouseStream.textfieldId.validation.isValid
                                  ? null
                                  : warehouseStream
                                      .textfieldId.validation.errorMessage,
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        controller: textController2,
                        onChanged: (value) {
                          context.read<WarehouseStreamCubit>().changeTextfield(
                                TextfieldModel(
                                  text: value,
                                  position:
                                      textController2.selection.base.offset,
                                ),
                                0,
                              );
                        },
                        onSubmitted: (value) {
                          context.read<WarehouseStreamCubit>().changeTextfield(
                                TextfieldModel(
                                  text: value,
                                  position:
                                      textController2.selection.base.offset,
                                ),
                                0,
                              );
                          context.read<WarehouseSettingCubit>().change();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Nombre de almacén'),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          isDense: true,
                          errorStyle: const TextStyle(height: 0.3),
                          errorText:
                              warehouseStream.textfieldName.validation.isValid
                                  ? null
                                  : warehouseStream
                                      .textfieldName.validation.errorMessage,
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        onChanged: (value) {
                          context.read<WarehouseStreamCubit>().changeTextfield(
                                TextfieldModel(
                                  text: value,
                                  position:
                                      textController.selection.base.offset,
                                ),
                                1,
                              );
                        },
                        onSubmitted: (value) {
                          context.read<WarehouseStreamCubit>().changeTextfield(
                                TextfieldModel(
                                  text: value,
                                  position:
                                      textController.selection.base.offset,
                                ),
                                1,
                              );
                          context.read<WarehouseSettingCubit>().change();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Encargado de almacén'),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: DropdownButton<String>(
                        underline:
                            warehouseStream.dropdownManager.validation.isValid
                                ? null
                                : Container(
                                    height: 2,
                                    color: Colors.red,
                                  ),
                        iconEnabledColor:
                            warehouseStream.dropdownManager.validation.isValid
                                ? null
                                : Colors.red,
                        isExpanded: true,
                        value: warehouseStream.dropdownManager.value == ''
                            ? null
                            : warehouseStream.dropdownManager.value,
                        items: users.map((element) {
                          return DropdownMenuItem<String>(
                              value: element.name, child: Text(element.name));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<WarehouseStreamCubit>()
                                .changeDropdown(value);
                          }
                          context.read<WarehouseSettingCubit>().change();
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              OutlinedButton(
                onPressed: () async {
                  context.read<WarehouseStreamCubit>().allValidate();
                  final currentStream =
                      context.read<WarehouseStreamCubit>().state;
                  if (settingMode == 0) {
                    final isExist = await context
                        .read<WarehouseSettingCubit>()
                        .add(currentStream);
                    if (isExist == true) {
                      warehouseStream.textfieldId.validation =
                          ValidationFormModel(
                              isValid: false, errorMessage: 'Clave existente');
                    }
                  } else if (settingMode == 1) {
                    context.read<WarehouseSettingCubit>().edit(currentStream);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
