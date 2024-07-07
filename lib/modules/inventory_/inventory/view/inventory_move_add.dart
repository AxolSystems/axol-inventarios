<<<<<<< HEAD
import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: avoid_web_libraries_in_flutter

import '../../../../models/data_find.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/data_state.dart';
import '../../../../utilities/format.dart';
import '../../../../utilities/widgets/navigation_rail/navigation_utilities.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../utilities/widgets/input_table.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../../../user/model/user_model.dart';
import '../../product/model/product_model.dart';
import '../../product/view/product_drawer_details.dart';
import '../../product/view/product_drawer_find.dart';
import '../cubit/inventory_move/inventory_move_cubit.dart';
import '../cubit/inventory_move/inventory_move_state.dart';
import '../model/inventory_move/inventory_move_model.dart';
import '../model/warehouse_model.dart';
import 'inventory_move_dialog_save.dart';

class InventoryMoveAdd extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryMoveAdd({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryMoveCubit()),
        BlocProvider(create: (_) => InventoryMoveForm()),
      ],
      child: InventoryMoveAddBuild(
        warehouse: warehouse,
      ),
    );
  }
}

class InventoryMoveAddBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryMoveAddBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    InventoryMoveModel form = context.read<InventoryMoveForm>().state;
    //ReportInventoryMoveModel reportData;

    return BlocConsumer<InventoryMoveCubit, InventoryMoveState>(
      bloc: context.read<InventoryMoveCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingInventoryMoveState) {
          return inventoryMoveAdd(context, true, form);
        } else if (state is LoadedInventoryMoveState) {
          return inventoryMoveAdd(context, false, form);
        } else {
          return inventoryMoveAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorInventoryMoveState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedInventoryMoveState) {
          showDialog(
              context: context,
              builder: (context) =>
                  InventoryMoveDialogSave(reportData: state.reportData));
        }
      },
    );
  }

  Widget inventoryMoveAdd(
      BuildContext context, bool isLoading, InventoryMoveModel form) {
    List<DropdownMenuEntry<int>> entryConceptList = [];
    List<DropdownMenuEntry<int>> entryWarehouseList = [];
    DropdownMenuEntry<int> entry;
    double totalWeight = 0;
    for (var concept in form.concepts) {
      entry = DropdownMenuEntry(
          value: concept.id, label: '${concept.id} - ${concept.text}');
      entryConceptList.add(entry);
    }
    for (var element in form.warehouseList) {
      if (element.id != warehouse.id) {
        entry = DropdownMenuEntry(
            value: element.id, label: '${element.id} - ${element.name}');
        entryWarehouseList.add(entry);
      }
    }
    for (var move in form.moveList) {
      totalWeight = move.weightTotal + totalWeight;
    }
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol.appBar(
        title: 'Movimiento al inventario',
        isLoading: isLoading,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationUtilities.emptyNavRailReturn(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: ColorPalette.darkItems20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        //Se uso el Visibility porque en mac no alcanzaba a cargar a tiempo
                        // la lista inicial de conceptos una vez pasaba a loaded.
                        Visibility(
                          visible: isLoading == false,
                          replacement: DropdownMenu(
                            width: 250,
                            enabled: !isLoading,
                            label: const Text(
                              'Concepto',
                              style: Typo.labelLight,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            trailingIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: ColorPalette.lightItems10,
                              size: 20,
                            ),
                            dropdownMenuEntries: const [],
                          ),
                          child: DropdownMenu(
                            controller: form.concept.id > -1
                                ? TextEditingController(
                                    text:
                                        '${form.concept.id} - ${form.concept.text}')
                                : null,
                            width: 250,
                            enabled: !isLoading,
                            textStyle: Typo.labelLight,
                            label: const Text(
                              'Concepto',
                              style: Typo.labelLight,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              isDense: true,
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.primary),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            trailingIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: ColorPalette.lightItems10,
                              size: 20,
                            ),
                            dropdownMenuEntries: entryConceptList,
                            onSelected: (value) {
                              if (value != null) {
                                final concept = form.concepts
                                    .where((x) => x.id == value)
                                    .first;
                                form.concept = concept;
                                if (concept.type == 1) {
                                  context
                                      .read<InventoryMoveCubit>()
                                      .allValidate(form, warehouse);
                                } else {
                                  context.read<InventoryMoveCubit>().load(form);
                                }
                              }
                            },
                          ),
                        ),
                        Visibility(
                            visible: form.concept.id == 58,
                            replacement: const SizedBox(width: 8),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownMenu(
                                width: 250,
                                enabled: !isLoading,
                                textStyle: Typo.labelLight,
                                label: const Text(
                                  'Destino',
                                  style: Typo.labelLight,
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  isDense: true,
                                  constraints: BoxConstraints.tight(
                                      const Size.fromHeight(34)),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.lightItems10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.lightItems10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorPalette.primary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                trailingIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: ColorPalette.lightItems10,
                                  size: 20,
                                ),
                                dropdownMenuEntries: entryWarehouseList,
                                onSelected: (value) {
                                  if (value != null) {
                                    final warehouseDestiny = form.warehouseList
                                        .where((x) => x.id == value)
                                        .first;
                                    form.invTransfer = warehouseDestiny;
                                    context
                                        .read<InventoryMoveCubit>()
                                        .load(form);
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: form.document,
                            enabled: !isLoading,
                            style: Typo.labelLight,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              labelText: 'Documento',
                              labelStyle: Typo.labelLight,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPalette.lightItems10),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPalette.lightItems10),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
                            onChanged: (value) {
                              form.document = TextEditingController.fromValue(
                                  TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              ));
                            },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          FormatDate.dmy(form.date),
                          style: Typo.labelLight,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Almacén: ${warehouse.name}',
                          style: Typo.labelLight,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              HeaderTable(dataList: [
                                DataTableAxol(text: 'Clave', flex: 2),
                                DataTableAxol(text: 'Descripción', flex: 4),
                                DataTableAxol(text: 'Cantidad', flex: 2),
                                DataTableAxol(text: 'Peso unitario', flex: 2),
                                DataTableAxol(text: 'Peso total', flex: 2),
                                DataTableAxol(text: 'Eliminar', flex: 1),
                              ]),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: form.moveList.length,
                                  itemBuilder: (context, index) {
                                    final row = form.moveList[index];
                                    return InputRow(children: [
                                      //---Clave
                                      TextFieldCell(
                                        flex: 2,
                                        enabled: !isLoading,
                                        controller: form.moveList[index].codeTf,
                                        isLoading: form.moveList[index]
                                                .codeState.state ==
                                            ElementState.loading,
                                        valid: ValidationFormModel(
                                            isValid: form.moveList[index]
                                                    .codeState.state !=
                                                ElementState.error,
                                            errorMessage: form.moveList[index]
                                                .codeState.message),
                                        onFocusChange: (value) {},
                                        borderColor: ColorPalette.darkItems20,
                                        suffixIcon: Icons.search,
                                        onChanged: (value) {
                                          form.moveList[index].codeTf.value =
                                              TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                        },
                                        onSubmitted: (value) {
                                          context
                                              .read<InventoryMoveCubit>()
                                              .enterCode(
                                                  index, form, warehouse);
                                        },
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductDrawerFind(
                                                    warehouse: warehouse),
                                          ).then((value) {
                                            if (value is DataFindValues &&
                                                value.data
                                                    is InventoryRowModel) {
                                              final InventoryRowModel
                                                  inventoryRow = value.data;
                                              form.moveList[index].codeTf
                                                      .value =
                                                  TextEditingValue(
                                                      text: inventoryRow
                                                          .product.code);
                                              context
                                                  .read<InventoryMoveCubit>()
                                                  .enterCode(
                                                      index, form, warehouse);
                                            } else if (value
                                                    is DataFindValues &&
                                                value.data is ProductModel) {
                                              final ProductModel product =
                                                  value.data;
                                              form.moveList[index].codeTf
                                                      .value =
                                                  TextEditingValue(
                                                      text: product.code);
                                              context
                                                  .read<InventoryMoveCubit>()
                                                  .load(form);
                                            }
                                          });
                                        },
                                      ),
                                      //---Descripción
                                      LabelCell(
                                        row.product.description,
                                        flex: 4,
                                        suffixIcon: Icons.arrow_outward,
                                        enabled: !isLoading,
                                        onPressedSuffix: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductDrawerDetails(
                                              product: row.product,
                                              user: UserModel.empty(),
                                            ),
                                          );
                                        },
                                      ),
                                      //---Cantidad
                                      TextFieldCell(
                                        flex: 2,
                                        enabled: !isLoading,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*$'))
                                        ],
                                        controller:
                                            form.moveList[index].quantityTf,
                                        isLoading: form.moveList[index]
                                                .quantityState.state ==
                                            ElementState.loading,
                                        valid: ValidationFormModel(
                                          isValid: form.moveList[index]
                                                  .quantityState.state !=
                                              ElementState.error,
                                          errorMessage: form.moveList[index]
                                              .quantityState.message,
                                        ),
                                        onFocusChange: (value) {},
                                        borderColor: ColorPalette.darkItems20,
                                        onChanged: (value) {
                                          form.moveList[index].quantityTf
                                              .value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                        },
                                        onSubmitted: (value) {
                                          context
                                              .read<InventoryMoveCubit>()
                                              .enterQuantity(
                                                  index, warehouse, form);
                                        },
                                      ),
                                      //---Peso unitario
                                      LabelCell(
                                        FormatNumber.format2dec(
                                            form.moveList[index].weightUnit),
                                        flex: 2,
                                      ),
                                      //---Peso total
                                      LabelCell(
                                        FormatNumber.format2dec(
                                            form.moveList[index].weightTotal),
                                        flex: 2,
                                      ),
                                      //---Eliminar
                                      ButtonCell(
                                          flex: 1,
                                          enabled: !isLoading,
                                          onPressed: () {
                                            form.moveList.removeAt(index);
                                            context
                                                .read<InventoryMoveCubit>()
                                                .load(form);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: ColorPalette.lightItems10,
                                          ))
                                    ]);
                                  },
                                ),
                              ),
                              Container(
                                color: ColorPalette.darkItems20,
                                child: Row(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      'Peso total: ${FormatNumber.format2dec(totalWeight)} kg',
                                      style: Typo.subtitleLight,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        HorizontalToolBar(
                          border: const Border(
                            top: BorderSide(color: ColorPalette.darkItems20),
                            left: BorderSide(color: ColorPalette.darkItems20),
                          ),
                          children: [
                            ButtonTool(
                              icon: Icons.add,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      form.moveList
                                          .add(InventoryMoveRowModel.empty());
                                      context
                                          .read<InventoryMoveCubit>()
                                          .load(form);
                                    },
                            ),
                            ButtonTool(
                              icon: Icons.save,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context
                                          .read<InventoryMoveCubit>()
                                          .save(form, warehouse);
                                    },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
=======
import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: avoid_web_libraries_in_flutter

import '../../../../models/data_find.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/data_state.dart';
import '../../../../utilities/format.dart';
import '../../../../utilities/widgets/navigation_rail/navigation_utilities.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../../../utilities/widgets/input_table.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../../../user/model/user_mdoel.dart';
import '../../product/model/product_model.dart';
import '../../product/view/product_drawer_details.dart';
import '../../product/view/product_drawer_find.dart';
import '../cubit/inventory_move/inventory_move_cubit.dart';
import '../cubit/inventory_move/inventory_move_state.dart';
import '../model/inventory_move/inventory_move_model.dart';
import '../model/warehouse_model.dart';
import 'inventory_move_dialog_save.dart';

class InventoryMoveAdd extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryMoveAdd({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryMoveCubit()),
        BlocProvider(create: (_) => InventoryMoveForm()),
      ],
      child: InventoryMoveAddBuild(
        warehouse: warehouse,
      ),
    );
  }
}

class InventoryMoveAddBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const InventoryMoveAddBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    InventoryMoveModel form = context.read<InventoryMoveForm>().state;
    //ReportInventoryMoveModel reportData;

    return BlocConsumer<InventoryMoveCubit, InventoryMoveState>(
      bloc: context.read<InventoryMoveCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingInventoryMoveState) {
          return inventoryMoveAdd(context, true, form);
        } else if (state is LoadedInventoryMoveState) {
          return inventoryMoveAdd(context, false, form);
        } else {
          return inventoryMoveAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorInventoryMoveState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedInventoryMoveState) {
          showDialog(
                  context: context,
                  builder: (context) =>
                      InventoryMoveDialogSave(reportData: state.reportData))
              .then((value) {
            Navigator.pop(context);
          });
        }
      },
    );
  }

  Widget inventoryMoveAdd(
      BuildContext context, bool isLoading, InventoryMoveModel form) {
    List<DropdownMenuEntry<int>> entryConceptList = [];
    List<DropdownMenuEntry<int>> entryWarehouseList = [];
    DropdownMenuEntry<int> entry;
    double totalWeight = 0;
    for (var concept in form.concepts) {
      entry = DropdownMenuEntry(
          value: concept.id, label: '${concept.id} - ${concept.text}');
      entryConceptList.add(entry);
    }
    for (var element in form.warehouseList) {
      if (element.id != warehouse.id) {
        entry = DropdownMenuEntry(
            value: element.id, label: '${element.id} - ${element.name}');
        entryWarehouseList.add(entry);
      }
    }
    for (var move in form.moveList) {
      totalWeight = move.weightTotal + totalWeight;
    }
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol.appBar(
        title: 'Movimiento al inventario',
        isLoading: isLoading,
      ),
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        //Se uso el Visibility porque en mac no alcanzaba a cargar a tiempo
                        // la lista inicial de conceptos una vez pasaba a loaded.
                        Visibility(
                          visible: isLoading == false,
                          replacement: DropdownMenu(
                            width: 250,
                            enabled: !isLoading,
                            label: const Text(
                              'Concepto',
                              style: Typo.labelLight,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            trailingIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: ColorPalette.lightItems10,
                              size: 20,
                            ),
                            dropdownMenuEntries: const [],
                          ),
                          child: DropdownMenu(
                            controller: form.concept.id > -1
                                ? TextEditingController(
                                    text:
                                        '${form.concept.id} - ${form.concept.text}')
                                : null,
                            width: 250,
                            enabled: !isLoading,
                            textStyle: Typo.labelLight,
                            label: const Text(
                              'Concepto',
                              style: Typo.labelLight,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              isDense: true,
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPalette.lightItems10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.primary),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            trailingIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: ColorPalette.lightItems10,
                              size: 20,
                            ),
                            dropdownMenuEntries: entryConceptList,
                            onSelected: (value) {
                              if (value != null) {
                                final concept = form.concepts
                                    .where((x) => x.id == value)
                                    .first;
                                form.concept = concept;
                                if (concept.type == 1) {
                                  context
                                      .read<InventoryMoveCubit>()
                                      .allValidate(form, warehouse);
                                } else {
                                  context.read<InventoryMoveCubit>().load(form);
                                }
                              }
                            },
                          ),
                        ),
                        Visibility(
                            visible: form.concept.id == 58,
                            replacement: const SizedBox(width: 8),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownMenu(
                                width: 250,
                                enabled: !isLoading,
                                textStyle: Typo.labelLight,
                                label: const Text(
                                  'Destino',
                                  style: Typo.labelLight,
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  isDense: true,
                                  constraints: BoxConstraints.tight(
                                      const Size.fromHeight(34)),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.lightItems10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.lightItems10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorPalette.primary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                trailingIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: ColorPalette.lightItems10,
                                  size: 20,
                                ),
                                dropdownMenuEntries: entryWarehouseList,
                                onSelected: (value) {
                                  if (value != null) {
                                    final warehouseDestiny = form.warehouseList
                                        .where((x) => x.id == value)
                                        .first;
                                    form.invTransfer = warehouseDestiny;
                                    context
                                        .read<InventoryMoveCubit>()
                                        .load(form);
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: form.document,
                            enabled: !isLoading,
                            style: Typo.labelLight,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              constraints: BoxConstraints.tight(
                                  const Size.fromHeight(34)),
                              labelText: 'Documento',
                              labelStyle: Typo.labelLight,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPalette.lightItems10),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPalette.lightItems10),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
                            onChanged: (value) {
                              form.document = TextEditingController.fromValue(
                                  TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              ));
                            },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          FormatDate.dmy(form.date),
                          style: Typo.labelLight,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Almacén: ${warehouse.name}',
                          style: Typo.labelLight,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              HeaderTable(dataList: [
                                DataTableAxol(text: 'Clave', flex: 2),
                                DataTableAxol(text: 'Descripción', flex: 4),
                                DataTableAxol(text: 'Cantidad', flex: 2),
                                DataTableAxol(text: 'Peso unitario', flex: 2),
                                DataTableAxol(text: 'Peso total', flex: 2),
                                DataTableAxol(text: 'Eliminar', flex: 1),
                              ]),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: form.moveList.length,
                                  itemBuilder: (context, index) {
                                    final row = form.moveList[index];
                                    return InputRow(children: [
                                      //---Clave
                                      TextFieldCell(
                                        flex: 2,
                                        enabled: !isLoading,
                                        controller: form.moveList[index].codeTf,
                                        isLoading: form.moveList[index]
                                                .codeState.state ==
                                            ElementState.loading,
                                        valid: ValidationFormModel(
                                            isValid: form.moveList[index]
                                                    .codeState.state !=
                                                ElementState.error,
                                            errorMessage: form.moveList[index]
                                                .codeState.message),
                                        onFocusChange: (value) {},
                                        borderColor: ColorPalette.darkItems,
                                        suffixIcon: Icons.search,
                                        onChanged: (value) {
                                          form.moveList[index].codeTf.value =
                                              TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                        },
                                        onSubmitted: (value) {
                                          context
                                              .read<InventoryMoveCubit>()
                                              .enterCode(
                                                  index, form, warehouse);
                                        },
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductDrawerFind(
                                                    warehouse: warehouse),
                                          ).then((value) {
                                            if (value is DataFindValues &&
                                                value.data
                                                    is InventoryRowModel) {
                                              final InventoryRowModel
                                                  inventoryRow = value.data;
                                              form.moveList[index].codeTf
                                                      .value =
                                                  TextEditingValue(
                                                      text: inventoryRow
                                                          .product.code);
                                              context
                                                  .read<InventoryMoveCubit>()
                                                  .enterCode(
                                                      index, form, warehouse);
                                            } else if (value
                                                    is DataFindValues &&
                                                value.data is ProductModel) {
                                              final ProductModel product =
                                                  value.data;
                                              form.moveList[index].codeTf
                                                      .value =
                                                  TextEditingValue(
                                                      text: product.code);
                                              context
                                                  .read<InventoryMoveCubit>()
                                                  .load(form);
                                            }
                                          });
                                        },
                                      ),
                                      //---Descripción
                                      LabelCell(
                                        row.product.description,
                                        flex: 4,
                                        suffixIcon: Icons.arrow_outward,
                                        enabled: !isLoading,
                                        onPressedSuffix: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductDrawerDetails(
                                              product: row.product,
                                              user: UserModel.empty(),
                                            ),
                                          );
                                        },
                                      ),
                                      //---Cantidad
                                      TextFieldCell(
                                        flex: 2,
                                        enabled: !isLoading,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*$'))
                                        ],
                                        controller:
                                            form.moveList[index].quantityTf,
                                        isLoading: form.moveList[index]
                                                .quantityState.state ==
                                            ElementState.loading,
                                        valid: ValidationFormModel(
                                          isValid: form.moveList[index]
                                                  .quantityState.state !=
                                              ElementState.error,
                                          errorMessage: form.moveList[index]
                                              .quantityState.message,
                                        ),
                                        onFocusChange: (value) {},
                                        borderColor: ColorPalette.darkItems,
                                        onChanged: (value) {
                                          form.moveList[index].quantityTf
                                              .value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                        },
                                        onSubmitted: (value) {
                                          context
                                              .read<InventoryMoveCubit>()
                                              .enterQuantity(
                                                  index, warehouse, form);
                                        },
                                      ),
                                      //---Peso unitario
                                      LabelCell(
                                        FormatNumber.format2dec(
                                            form.moveList[index].weightUnit),
                                        flex: 2,
                                      ),
                                      //---Peso total
                                      LabelCell(
                                        FormatNumber.format2dec(
                                            form.moveList[index].weightTotal),
                                        flex: 2,
                                      ),
                                      //---Eliminar
                                      ButtonCell(
                                          flex: 1,
                                          enabled: !isLoading,
                                          onPressed: () {
                                            form.moveList.removeAt(index);
                                            context
                                                .read<InventoryMoveCubit>()
                                                .load(form);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: ColorPalette.lightItems10,
                                          ))
                                    ]);
                                  },
                                ),
                              ),
                              Container(
                                color: ColorPalette.darkItems,
                                child: Row(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      'Peso total: ${FormatNumber.format2dec(totalWeight)} kg',
                                      style: Typo.subtitleLight,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        HorizontalToolBar(
                          border: const Border(
                            top: BorderSide(color: ColorPalette.darkItems),
                            left: BorderSide(color: ColorPalette.darkItems),
                          ),
                          children: [
                            ButtonTool(
                              icon: Icons.add,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      form.moveList
                                          .add(InventoryMoveRowModel.empty());
                                      context
                                          .read<InventoryMoveCubit>()
                                          .load(form);
                                    },
                            ),
                            ButtonTool(
                              icon: Icons.save,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context
                                          .read<InventoryMoveCubit>()
                                          .save(form, warehouse);
                                    },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
>>>>>>> main
