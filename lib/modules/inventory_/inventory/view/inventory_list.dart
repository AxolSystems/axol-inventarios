import 'package:axol_inventarios/modules/inventory_/inventory/model/warehouse_model.dart';
import 'package:axol_inventarios/modules/inventory_/inventory/view/inventory_move_add.dart';
import 'package:axol_inventarios/utilities/navigation_utilities.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../../product/view/product_drawer_details.dart';
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
      bloc: context.read<InventoryListCubit>()..initLoad(warehouse, form),
      builder: (context, state) {
        if (state is LoadingInventoryListState) {
          return inventoryList(context, true, [], form);
        } else if (state is LoadedInventoryListState) {
          return inventoryList(context, false, state.inventoryRowList, form);
        } else {
          return inventoryList(context, false, [], form);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget inventoryList(BuildContext context, bool isLoading,
      List<InventoryRowModel> inventoryRowList, TableViewFormModel form) {
    TextEditingController textController = TextEditingController.fromValue(
        TextEditingValue(
            text: form.finder.text,
            selection: TextSelection.collapsed(offset: form.finder.position)));

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
                VerticalToolBar(children: [
                  Expanded(
                      child: FinderBar(
                    padding: const EdgeInsets.only(left: 12),
                    textController: textController,
                    txtForm: form.finder,
                    enabled: !isLoading,
                    autoFocus: true,
                    isTxtExpand: true,
                    onSubmitted: (value) {
                      context.read<InventoryListCubit>().load(warehouse, form);
                    },
                    onChanged: (value) {
                      form.finder = TextfieldModel(
                        text: value,
                        position: textController.selection.base.offset,
                      );
                    },
                    onPressed: () {
                      if (isLoading == false) {
                        form.finder = TextfieldModel.empty();
                        context
                            .read<InventoryListCubit>()
                            .load(warehouse, form);
                      }
                    },
                  )),
                  const VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: ColorPalette.lightItems10,
                    indent: 4,
                    endIndent: 4,
                  ),
                  Visibility(
                    visible: warehouse.id != -2,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => InventoryMoveAdd(
                            warehouse: warehouse,
                          ),
                        ).then((value) {
                          context
                              .read<InventoryListCubit>()
                              .load(warehouse, form);
                        });
                      },
                      icon: const Icon(
                        Icons.add_outlined,
                        color: ColorPalette.darkItems,
                        size: 30,
                      ),
                    ),
                  ),
                ]),
                Visibility(
                    visible: warehouse.id == -2,
                    replacement: HeaderTable(
                      dataList: [
                        DataTableAxol.text('Clave'),
                        DataTableAxol(
                          text: 'Descripción',
                          flex: 3,
                        ),
                        DataTableAxol.text('Stock'),
                      ],
                    ),
                    child: HeaderTable(
                      dataList: [
                        DataTableAxol.text('Almacén'),
                        DataTableAxol.text('Clave'),
                        DataTableAxol(
                          text: 'Descripción',
                          flex: 3,
                        ),
                        DataTableAxol.text('Stock'),
                      ],
                    )),
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ProductDrawerDetails(
                                  product: inventoryRow.product,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Visibility(
                                  visible: warehouse.id == -2,
                                  child: Expanded(
                                      flex: 1,
                                      child: Text(
                                        inventoryRow.warehouseName,
                                        style: Typo.bodyLight,
                                        textAlign: TextAlign.center,
                                      )),
                                ),
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
                NavigateBarTable(
                  currentPage: form.currentPage,
                  limitPaga: form.limitPage,
                  totalReg: form.totalReg,
                  onPressedLeft: () {
                    if (form.currentPage > 1) {
                      form.currentPage = form.currentPage - 1;
                      context.read<InventoryListCubit>().load(warehouse, form);
                    }
                  },
                  onPressedRight: () {
                    if (form.currentPage < form.limitPage) {
                      form.currentPage = form.currentPage + 1;
                      context.read<InventoryListCubit>().load(warehouse, form);
                    }
                  },
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
