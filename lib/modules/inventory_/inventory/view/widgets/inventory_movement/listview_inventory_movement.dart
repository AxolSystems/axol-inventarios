import 'package:axol_inventarios/modules/inventory_/inventory/cubit/inventory_movements/moves_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/inventory_move/inventory_move_row_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utilities/data_state.dart';
import '../../../model/inventory_move/inventory_move_model.dart';
import '../../../../../../models/movement_transfer_model.dart';
import '../../../../../../utilities/theme/theme.dart';
import '../../../cubit/inventory_load/inventory_load_cubit.dart';
import '../../../cubit/inventory_movements/inventory_moves_cubit.dart';
import '../../../cubit/show_details_product_stock/showdetails_productstock_cubit.dart';
import '../../../cubit/transfer_cubit.dart';
import '../../../cubit/textfield_finder_invrow_cubit.dart';
import '../../controllers/opendetails_productstock_controller.dart';
import 'drawer_find_product.dart';
import 'package:shimmer/shimmer.dart';

class ListviewInventoryMovement extends StatelessWidget {
  final WarehouseModel warehouse;
  final List<WarehouseModel> warehouseList;

  const ListviewInventoryMovement({super.key, required this.warehouse, required this.warehouseList});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    InventoryMoveModel form = context.read<MovesFormCubit>().state;
    List<InventoryMoveRowModel> products = [];
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(
          width: screenWidth > 600 ? screenWidth - 230 : 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white30,
                height: 30,
                child: BlocBuilder<TransferCubit, MovementTransferModel>(
                  builder: (context, state) {
                    if (form.states[form.tConcepts]!.state ==
                        ElementState.loaded) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        children: [
                          DropdownButton<String>(
                            value: form.concepts
                                    .map((element) {
                                      return element.text;
                                    })
                                    .toList()
                                    .contains(form.concept.text)
                                ? form.concept.text
                                : null,
                            items: form.concepts.map((element) {
                              return DropdownMenuItem(
                                  value: element.text,
                                  child: Text(element.text));
                            }).toList(),
                            onChanged: (value) {
                              context
                                  .read<InventoryMovesCubit>()
                                  .checkErrorsMoveList(form, warehouse);
                              context.read<MovesFormCubit>().setConcept(form
                                  .concepts
                                  .where((x) => x.text == value)
                                  .first);
                              form = context.read<MovesFormCubit>().state;
                              context.read<InventoryMovesCubit>().load(form);
                              if (value == 'Salida por traspaso') {
                                context.read<TransferCubit>().change(
                                    true, warehouse.name, state.inventory2, 1);
                              } else {
                                context
                                    .read<TransferCubit>()
                                    .change(false, '', '', 0);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Visibility(
                              visible: context
                                  .read<TransferCubit>()
                                  .state
                                  .inventories
                                  .isNotEmpty,
                              child: DropdownButton(
                                value: state.inventories
                                        .map((e) {
                                          return e;
                                        })
                                        .toList()
                                        .contains(state.inventory2)
                                    ? state.inventory2
                                    : null,
                                items: state.inventories.map((e) {
                                  return DropdownMenuItem(
                                      value: e, child: Text(e));
                                }).toList(),
                                onChanged: (value) {
                                  final warehouse2 = warehouseList.where((x) => x.name == value).first;
                                  context.read<TransferCubit>().change(true,
                                      state.inventory1, value!, state.concept);
                                  context
                                      .read<InventoryMovesCubit>()
                                      .invTransfer(form, warehouse2);
                                },
                              )),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: 'Documento',
                              ),
                              onChanged: (value) {
                                context
                                    .read<MovesFormCubit>()
                                    .setDocument(value);
                                context.read<InventoryMovesCubit>().load(form);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Center(
                              child: Text(
                                  '${form.date.day}/${form.date.month}/${form.date.year}')),
                        ],
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.black26,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              width: 200,
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.black26,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              width: 200,
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.black26,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              width: 200,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Clave',
                      style: Typo.labelText1,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Descripción',
                      style: Typo.labelText1,
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Cantidad',
                      style: Typo.labelText1,
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Peso unitario',
                      style: Typo.labelText1,
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Peso total',
                      style: Typo.labelText1,
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      '',
                      style: Typo.labelText1,
                    )),
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: form.moveList.length,
                itemBuilder: ((context, index) {
                  TextEditingController txtCode = TextEditingController();
                  final moveRow = form.moveList[index];
                  return Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45)),
                    child: Row(
                      //1) Clave
                      children: [
                        Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Focus(
                                    onFocusChange: (value) {
                                      if (value == false) {
                                        context
                                            .read<InventoryMovesCubit>()
                                            .enterCode(index, form,
                                                txtCode.text, warehouse);
                                      }
                                    },
                                    child: TextField(
                                      controller: txtCode
                                        ..text = moveRow.code.toString()
                                        ..selection = TextSelection.collapsed(
                                            offset:
                                                moveRow.code.toString().length),
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: moveRow
                                                            .states[
                                                                moveRow.tCode]!
                                                            .state ==
                                                        ElementState.error
                                                    ? ColorPalette.caution
                                                    : ColorPalette.primary)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: moveRow
                                                            .states[
                                                                moveRow.tCode]!
                                                            .state ==
                                                        ElementState.error
                                                    ? ColorPalette.caution
                                                    : ColorPalette.secondary)),
                                        isDense: true,
                                      ),
                                      onSubmitted: (value) {
                                        context
                                            .read<InventoryMovesCubit>()
                                            .enterCode(
                                                index, form, value, warehouse);
                                      },
                                      onChanged: (value) {
                                        form.moveList[index].code = value;
                                        context
                                            .read<MovesFormCubit>()
                                            .setForm(form);
                                      },
                                      style: Typo.labelText1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 30,
                                  child: IconButton(
                                    onPressed: () {
                                      if (form.concept.type > -1) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                  create: (_) =>
                                                      InventoryLoadCubit()),
                                              BlocProvider(
                                                  create: (_) =>
                                                      TextfieldFinderInvrowCubit()),
                                            ],
                                            child: DrawerFindProduct(
                                              inventoryName: warehouse.name,
                                              concept: form.concept,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value is String) {
                                            context
                                                .read<MovesFormCubit>()
                                                .setCodeMoveRow(value, index);
                                            context
                                                .read<InventoryMovesCubit>()
                                                .enterCode(index, form, value,
                                                    warehouse);
                                          }
                                          //txtCode.text = value.toString();
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Alerta!'),
                                            content: const Text(
                                              'Seleccione un concepto',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Aceptar'),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.search,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        //2) Descripcion
                        Expanded(
                          flex: 2,
                          child: Center(child: Builder(
                            builder: (context) {
                              if (moveRow.states[moveRow.tCode]!.state ==
                                  ElementState.loading) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white12,
                                  highlightColor: Colors.white24,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    width: 200,
                                  ),
                                );
                              } else if (moveRow.states[moveRow.tCode]!.state ==
                                  ElementState.loaded) {
                                return TextButton(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          BlocProvider(
                                            create: (_) =>
                                                ShowDetailsProductStockCubit(),
                                            child:
                                                OpenDetailsProductStockController(
                                              code: moveRow.code,
                                              inventoryName: warehouse.name,
                                            ),
                                          )),
                                  child: Text(moveRow.description,
                                      style: Typo.labelText1),
                                );
                              } else if (moveRow.states[moveRow.tCode]!.state ==
                                      ElementState.error &&
                                  moveRow.states[moveRow.tCode]!.message ==
                                      moveRow.emNotProduct) {
                                return const Text('Producto no existente',
                                    style: Typo.labelError);
                              } else {
                                return const Text('');
                              }
                            },
                          )),
                        ),
                        //3) Cantidad
                        Expanded(
                          flex: 1,
                          child: Focus(
                              onFocusChange: (value) {
                                if (value == false) {
                                  if (form.concept.text != '') {
                                    form = context.read<MovesFormCubit>().state;
                                    context
                                        .read<InventoryMovesCubit>()
                                        .enterQuantity(index, warehouse, form);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Alerta!'),
                                        content: const Text(
                                            'Seleccione un concepto.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Aceptar'),
                                          )
                                        ],
                                      ),
                                    ).then(
                                      (value) {
                                        context
                                            .read<MovesFormCubit>()
                                            .setQuantityMovRow(0, index);
                                        form = context
                                            .read<MovesFormCubit>()
                                            .state;
                                        context
                                            .read<InventoryMovesCubit>()
                                            .load(form);
                                      },
                                    );
                                  }
                                }
                              },
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              moveRow.states[moveRow.tQuantity]!
                                                          .state ==
                                                      ElementState.error
                                                  ? ColorPalette.caution
                                                  : ColorPalette.primary)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              moveRow.states[moveRow.tQuantity]!
                                                          .state ==
                                                      ElementState.error
                                                  ? ColorPalette.caution
                                                  : ColorPalette.secondary)),
                                  isDense: true,
                                ),
                                controller: TextEditingController()
                                  ..text = moveRow.quantity.toString()
                                  ..selection = TextSelection.collapsed(
                                      offset:
                                          moveRow.quantity.toString().length),
                                style: Typo.labelText1,
                                onSubmitted: (value) {
                                  if (form.concept.text != '') {
                                    form = context.read<MovesFormCubit>().state;
                                    context
                                        .read<InventoryMovesCubit>()
                                        .enterQuantity(index, warehouse, form);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Alerta!'),
                                        content: const Text(
                                            'Seleccione un concepto.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Aceptar'),
                                          )
                                        ],
                                      ),
                                    ).then(
                                      (value) {
                                        context
                                            .read<MovesFormCubit>()
                                            .setQuantityMovRow(0, index);
                                        form = context
                                            .read<MovesFormCubit>()
                                            .state;
                                        context
                                            .read<InventoryMovesCubit>()
                                            .load(form);
                                      },
                                    );
                                  }
                                },
                                onChanged: (value) {
                                  context
                                      .read<MovesFormCubit>()
                                      .setQuantityMovRow(
                                          double.tryParse(value) ?? 0, index);
                                },
                              )),
                        ),
                        //4) Peso unitario
                        Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                            moveRow.weightUnit.toString(),
                            style: Typo.labelText1,
                          )),
                        ),
                        //5) Pesto total
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: moveRow.states[moveRow.tQuantity]!.state ==
                                    ElementState.error
                                ? Text(
                                    moveRow.states[moveRow.tQuantity]!.message!,
                                    style: Typo.labelError,
                                  )
                                : Text(
                                    moveRow.weightTotal.toStringAsFixed(2),
                                    style: Typo.labelText1,
                                  ),
                          ),
                        ),
                        //6) Eliminar fila
                        Expanded(
                          flex: 1,
                          child: Center(child: Builder(
                            builder: (context) {
                              if (moveRow.states[moveRow.tCode]!.state ==
                                      ElementState.loading ||
                                  moveRow.states[moveRow.tQuantity]!.state ==
                                      ElementState.loading) {
                                return const SizedBox(
                                  height: 8,
                                  width: 8,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.grey,
                                    strokeWidth: 4,
                                  ),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {
                                    products = form.moveList;
                                    products.removeAt(index);
                                    form.moveList = products;
                                    context
                                        .read<MovesFormCubit>()
                                        .setProducts(products);
                                    context
                                        .read<InventoryMovesCubit>()
                                        .load(form);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          )),
                        ),
                      ],
                    ),
                  );
                }),
              )),
            ],
          ),
        )
      ],
    );
  }
}
