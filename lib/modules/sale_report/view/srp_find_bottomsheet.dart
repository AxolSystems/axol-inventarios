import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/inventory_row_model.dart';
import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/add/srp_find_bottomsheet_cubit.dart';
import '../model/srp_find_bottomsheet_form_model.dart';

class SrpFindBottomsheet extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const SrpFindBottomsheet({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpFindBottomsheetCubit()),
        BlocProvider(create: (_) => SrpFindBottomsheetForm()),
      ],
      child: SrpFindBottomsheetBuild(inventoryRowList: inventoryRowList),
    );
  }
}

class SrpFindBottomsheetBuild extends StatelessWidget {
  final List<InventoryRowModel> inventoryRowList;
  const SrpFindBottomsheetBuild({super.key, required this.inventoryRowList});

  @override
  Widget build(BuildContext context) {
    SrpFindBottomsheetFormModel form =
        context.read<SrpFindBottomsheetForm>().state;
    if (form.controller.text == '') {
      form.inventoryRowList = inventoryRowList;
    }
    return BlocConsumer<SrpFindBottomsheetCubit, SrpFindBottomsheetState>(
      bloc: context.read<SrpFindBottomsheetCubit>()..load(form),
      builder: (context, state) {
        if (state == SrpFindBottomsheetState.loading) {
          return srpFindBottomsheet(context, true, form, inventoryRowList);
        } else if (state == SrpFindBottomsheetState.load) {
          return srpFindBottomsheet(context, false, form, inventoryRowList);
        } else {
          return srpFindBottomsheet(context, false, form, inventoryRowList);
        }
      },
      listener: (context, state) {
        if (state == SrpFindBottomsheetState.error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: form.errorMessage ?? '',
                  ));
        }
      },
    );
  }

  Widget srpFindBottomsheet(
    BuildContext context,
    bool isLoading,
    SrpFindBottomsheetFormModel form,
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
                          .read<SrpFindBottomsheetCubit>()
                          .find(form, inventoryRowList);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: ColorPalette.lightItems10,
                    )),
              ),
              onSubmitted: (value) {
                context
                    .read<SrpFindBottomsheetCubit>()
                    .find(form, inventoryRowList);
              },
              onChanged: (value) {
                context
                    .read<SrpFindBottomsheetCubit>()
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