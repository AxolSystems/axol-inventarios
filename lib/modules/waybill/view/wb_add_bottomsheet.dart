import 'dart:js';

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
        BlocProvider(create: (_) => WbBottomSheetForm()),
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
    WbBottomSheetFormModel form = context.read<WbBottomSheetForm>().state;
    print(form.itemValue);
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
                    text: form.errorMessage,
                  ));
        }
      },
    );
  }

  Widget wbAddBottomSheet(
    BuildContext context,
    List<InventoryRowModel> inventoryList,
    WbBottomSheetFormModel form,
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Cantidad',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
