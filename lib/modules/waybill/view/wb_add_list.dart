import 'package:axol_inventarios/modules/waybill/view/wb_add_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/appbar_axol/appbar_axol.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/wb_add/wb_add_cubit.dart';
import '../cubit/wb_add/wb_add_state.dart';
import '../model/wb_add_form_model.dart';
import 'wb_add_details_bottomsheet.dart';

class WbAddList extends StatelessWidget {
  final WarehouseModel warehouse;
  const WbAddList({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddCubit()),
        BlocProvider(create: (_) => WbAddForm()),
      ],
      child: WbAddListBuild(
        warehouse: warehouse,
      ),
    );
  }
}

class WbAddListBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const WbAddListBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    WbAddFormModel form = context.read<WbAddForm>().state;
    return BlocConsumer<WbAddCubit, WbAddState>(
      bloc: context.read<WbAddCubit>()..initLoad(warehouse, form),
      builder: (context, state) {
        if (state is LoadingWbAddState) {
          return wbAdd(context, true, form);
        } else if (state is LoadedWbAddState) {
          return wbAdd(context, false, form);
        } else {
          return wbAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorWbAddState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
        if (state is SavedWbAddState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget wbAdd(BuildContext context, bool isLoading, WbAddFormModel form) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol.appBar(
        title: 'Nueva lista',
        isLoading: isLoading,
        leading: const LeadingReturn(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Almacén: ${warehouse.id} - ${warehouse.name}',
              style: Typo.subtitleLight,
              overflow: TextOverflow.fade,
            ),
          ),
          Container(
            color: ColorPalette.darkItems,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Clave',
                        style: Typo.subtitleLight,
                        textAlign: TextAlign.left,
                      )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Descripción',
                        style: Typo.subtitleLight,
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Cantidad',
                        style: Typo.subtitleLight,
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isLoading,
            replacement: const Expanded(child: SizedBox()),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: form.waybillList.length,
                itemBuilder: (context, index) {
                  final waybill = form.waybillList[index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorPalette.darkItems),
                      ),
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: BorderSide.none),
                      onPressed: () {},
                      onLongPress: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))),
                          context: context,
                          builder: (context) => WbAddDetailsBottomsheet(
                            form: form,
                            index: index,
                            inventoryRow: form.inventoryList
                                .where((x) =>
                                    x.product.code == waybill.product.code)
                                .first,
                          ),
                        ).then((value) {
                          context.read<WbAddCubit>().load();
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  waybill.product.code,
                                  style: Typo.bodyLight,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  waybill.product.description,
                                  style: Typo.bodyLight,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  waybill.stock.toString(),
                                  style: Typo.bodyLight,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: ColorPalette.lightItems10),
                        ),
                        onPressed: () {
                          context.read<WbAddCubit>().save(form);
                        },
                        child: const Icon(
                          Icons.save,
                          color: ColorPalette.lightItems10,
                          size: 26,
                        )),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ColorPalette.primary,
                        side: const BorderSide(
                          color: ColorPalette.primary,
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))),
                          context: context,
                          builder: (context) => WbAddBottomSheet(
                              inventoryList: form.inventoryList),
                        ).then((value) {
                          if (value is InventoryRowModel) {
                            form.waybillList.add(value);
                            context.read<WbAddCubit>().load();
                          }
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.add,
                              color: ColorPalette.lightBackground,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Agregar',
                              style: Typo.mobileLigth20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
