import 'package:axol_inventarios/models/validation_form_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_find.dart';
import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/data_state.dart';
import '../../../../utilities/format.dart';
import '../../../../utilities/navigation_utilities.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/appbar_axol.dart';
import '../../../../utilities/widgets/input_table.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../../product/model/product_model.dart';
import '../../product/view/product_drawer_details.dart';
import '../../product/view/product_drawer_find.dart';
import '../cubit/inventory_move/inventory_move_cubit.dart';
import '../cubit/inventory_move/inventory_move_state.dart';
import '../model/inventory_move/inventory_move_model.dart';
import '../model/warehouse_model.dart';

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
              builder: (context) => AlertDialogAxol(
                    text: 'Guardado',
                    icon: Icons.check_circle,
                    iconColor: ColorPalette.correct,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ));
        }
      },
    );
  }

  Widget inventoryMoveAdd(
      BuildContext context, bool isLoading, InventoryMoveModel form) {
    List<DropdownMenuEntry<int>> entryConceptList = [];
    List<DropdownMenuEntry<int>> entryWarehouseList = [];
    DropdownMenuEntry<int> entry;
    for (var element in form.concepts) {
      entry = DropdownMenuEntry(
          value: element.id, label: '${element.id} - ${element.text}');
      entryConceptList.add(entry);
    }
    for (var element in form.warehouseList) {
      entry = DropdownMenuEntry(
          value: element.id, label: '${element.id} - ${element.name}');
      entryWarehouseList.add(entry);
    }
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol(
        title: 'Movimiento al inventario',
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        DropdownMenu(
                          width: 250,
                          //controller: form.tfWarehose.controller,
                          enabled: !isLoading,
                          textStyle: Typo.labelLight,
                          label: const Text(
                            'Concepto',
                            style: Typo.labelLight,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            isDense: true,
                            constraints:
                                BoxConstraints.tight(const Size.fromHeight(34)),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.lightItems10),
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
                        Visibility(
                            visible: form.concept.id == 58,
                            replacement: const SizedBox(width: 8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                    final warehouse = form.warehouseList
                                        .where((x) => x.id == value)
                                        .first;
                                    form.invTransfer = warehouse;
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          width: 250,
                          child: TextField(
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
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
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
                                DataTableAxol.text('Clave'),
                                DataTableAxol.text('Descripción'),
                                DataTableAxol.text('Cantidad'),
                                DataTableAxol.text('Peso unitario'),
                                DataTableAxol.text('Peso total'),
                                DataTableAxol.text('Eliminar'),
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
                                        suffixIcon: Icons.arrow_outward,
                                        onPressedSuffix: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductDrawerDetails(
                                                    product: row.product),
                                          );
                                        },
                                      ),
                                      //---Cantidad
                                      TextFieldCell(
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
                                      LabelCell(form.moveList[index].weightUnit
                                          .toString()),
                                      //---Peso total
                                      LabelCell(form.moveList[index].weightTotal
                                          .toString()),
                                      ButtonCell(
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
                              onPressed: () {
                                form.moveList
                                    .add(InventoryMoveRowModel.empty());
                                context.read<InventoryMoveCubit>().load(form);
                              },
                            ),
                            ButtonTool(
                              icon: Icons.save,
                              onPressed: () {
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
