import 'package:axol_inventarios/modules/waybill/cubit/wb_add/wb_bottomsheet_find_cubit.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../model/wb_bottomsheet_find_form_model.dart';

class WbAddBottomsheetFind extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const WbAddBottomsheetFind({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbBottomSheetFindCubit()),
        BlocProvider(create: (_) => WbBottomSheetFindForm()),
      ],
      child: WbAddBottomsheetFindBuild(inventoryRowList: inventoryRowList),
    );
  }
}

class WbAddBottomsheetFindBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const WbAddBottomsheetFindBuild({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    WbBottomSheetFindFormModel form =
        context.read<WbBottomSheetFindForm>().state;
    if (form.controller.text == '') {
      form.inventoryRowList = inventoryRowList;
    }
    return BlocConsumer<WbBottomSheetFindCubit, WbBottomSheetFindState>(
      bloc: context.read<WbBottomSheetFindCubit>()..load(form),
      builder: (context, state) {
        if (state == WbBottomSheetFindState.loading) {
          return wbAddBottomsheetFind(context, true, form, inventoryRowList);
        } else if (state == WbBottomSheetFindState.load) {
          return wbAddBottomsheetFind(context, false, form, inventoryRowList);
        } else {
          return wbAddBottomsheetFind(context, false, form, inventoryRowList);
        }
      },
      listener: (context, state) {
        if (state == WbBottomSheetFindState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? '',
                  ));
        }
      },
    );
  }

  Widget wbAddBottomsheetFind(
    BuildContext context,
    bool isLoading,
    WbBottomSheetFindFormModel form,
    List<InventoryRowModel> inventoryRowList,
  ) {
    final double heightScreen = MediaQuery.of(context).size.height;
    return SizedBox(
      height: heightScreen * 0.7,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              controller: form.controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      context
                          .read<WbBottomSheetFindCubit>()
                          .find(form, inventoryRowList);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: ColorPalette.lightItems10,
                    )),
              ),
              onSubmitted: (value) {
                context
                    .read<WbBottomSheetFindCubit>()
                    .find(form, inventoryRowList);
              },
              onChanged: (value) {
                context
                    .read<WbBottomSheetFindCubit>()
                    .find(form, inventoryRowList);
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: form.inventoryRowList.length,
            itemBuilder: (context, index) {
              final row = form.inventoryRowList[index];
              return OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  onPressed: () {
                    Navigator.pop(context, row);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border.symmetric(
                            horizontal: BorderSide(
                                color: ColorPalette.lightItems20, width: 0.5))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Clave',
                                    style: Typo.smallLabelDark,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    row.product.code,
                                    style: Typo.bodyDark,
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                            const SizedBox(width: 8),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Stock',
                                    style: Typo.smallLabelDark,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    FormatNumber.format2dec(row.stock),
                                    style: Typo.bodyDark,
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Descripción',
                                  style: Typo.smallLabelDark,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  row.product.description,
                                  style: Typo.bodyDark,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ));
            },
          )),
        ],
      ),
    );
  }
}
