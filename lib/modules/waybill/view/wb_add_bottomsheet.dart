import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/wb_add/wb_add_bottomsheet_cubit.dart';
import '../model/wb_bottomsheet_form_model.dart';

class WbAddBottomSheet extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  const WbAddBottomSheet({super.key, required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddBottomSheetCubit()),
        BlocProvider(create: (_) => WbBottomSheetAddForm()),
      ],
      child: WbAddBottomSheetBuild(inventoryList: inventoryList),
    );
  }
}

class WbAddBottomSheetBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryList;
  const WbAddBottomSheetBuild({super.key, required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    WbBottomSheetAddFormModel form = context.read<WbBottomSheetAddForm>().state;
    if (form.itemValue == '') {
      form.itemValue = inventoryList.first.product.code;
      form.stock = inventoryList
          .where((x) => x.product.code == form.itemValue)
          .first
          .stock;
      form.product = inventoryList
          .where((x) => x.product.code == form.itemValue)
          .first
          .product;
    }
    return BlocConsumer<WbAddBottomSheetCubit, WbAddBottomSheetState>(
      bloc: context.read<WbAddBottomSheetCubit>()
        ..initLoad(form, inventoryList.first.product.code),
      builder: (context, state) {
        if (state == WbAddBottomSheetState.loading) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else if (state == WbAddBottomSheetState.load) {
          return wbAddBottomSheet(context, inventoryList, form);
        } else {
          return wbAddBottomSheet(context, inventoryList, form);
        }
      },
      listener: (context, state) {
        if (state == WbAddBottomSheetState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? 'null',
                  ));
        }
        if (state == WbAddBottomSheetState.save) {
          final InventoryRowModel inventoryRow = InventoryRowModel(
            product: form.product,
            stock: double.parse(form.controller.text),
            warehouseName: inventoryList.first.warehouseName,
          );
          Navigator.pop(
            context,
            inventoryRow,
          );
        }
      },
    );
  }

  Widget wbAddBottomSheet(
    BuildContext context,
    List<InventoryRowModel> inventoryList,
    WbBottomSheetAddFormModel form,
  ) {
    List<DropdownMenuItem<String>> itemList = [];
    DropdownMenuItem<String> item;
    for (var element in inventoryList) {
      item = DropdownMenuItem(
        value: element.product.code,
        child: Text(
          '${element.product.code}: ${element.stock}\n${element.product.description}',
          style: Typo.bodyDark,
          overflow: TextOverflow.visible,
        ),
      );
      itemList.add(item);
    }
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const SizedBox(height: 8),
          DropdownButtonFormField(
            padding: const EdgeInsets.all(8),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder()),
            isDense: false,
            itemHeight: 60,
            value: form.itemValue,
            items: itemList,
            onChanged: (value) {
              if (value != null) {
                form.itemValue = value;
                form.stock = inventoryList
                    .where((x) => x.product.code == value)
                    .first
                    .stock;
                form.product = inventoryList
                    .where((x) => x.product.code == value)
                    .first
                    .product;
                context.read<WbAddBottomSheetCubit>().load(form);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              style: Typo.bodyDark,
              controller: form.controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Cantidad',
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                errorText: form.errorMessage,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(8),
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
                  context.read<WbAddBottomSheetCubit>().save(form);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.save,
                        color: ColorPalette.lightBackground,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Guardar',
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
    );
  }
}
