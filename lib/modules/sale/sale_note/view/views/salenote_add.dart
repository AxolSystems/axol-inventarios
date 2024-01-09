import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/appbar/appbar_global.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/salenote_add/salenote_add_cubit.dart';
import '../../cubit/salenote_add/salenote_add_state.dart';
import '../../model/salenote_row_form_model.dart';

class SaleNoteAdd extends StatelessWidget {
  const SaleNoteAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteAddCubit, SaleNoteAddState>(
      bloc: context.read<SaleNoteAddCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingSaleNoteAddState) {
        } else if (state is LoadedSaleNoteAddState) {
        } else {}
      },
      listener: (context, state) {
        if (state is ErrorSaleNoteAddState) {}
      },
    );
  }

  Widget saleNoteAdd(
      BuildContext context, List<SaleNoteRowFormModel> rowFormList) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarGlobal(
          title: 'Nota de venta',
          iconButton: null,
          iconActions: [],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            leading: const ButtonReturnView(),
            destinations: NavigationUtilities.navRailReturn,
            selectedIndex: -1,
            backgroundColor: ColorPalette.darkBackground,
            indicatorColor: ColorPalette.primary,
          ),
          const VerticalDivider(
              thickness: 1, width: 1, color: ColorPalette.darkItems),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [],
                ),
                Container(
                  decoration: BoxDecorationTheme.headerTable(),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Cantidad', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Producto', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Descripición', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            Text('Precio unitario', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Subtotal', style: Typo.subtitleLight),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('Nota', style: Typo.subtitleLight),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rowFormList.length,
                    itemBuilder: (context, index) {
                      final row = rowFormList[index];
                      //final total = 
                      return Container(
                        decoration: BoxDecorationTheme.rowTable(),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(child: TextField()),
                                  IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.search),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(row.description),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(row.description),
                            ),
                          ],
                        ),
                      );
                    },
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
