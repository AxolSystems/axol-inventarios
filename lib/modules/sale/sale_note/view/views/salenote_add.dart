import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/appbar/appbar_global.dart';
import '../../../../../utilities/navigation_utilities.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/btn_select_inptu_form.dart';
import '../../../customer/model/customer_model.dart';
import '../../cubit/salenote_add/salenote_add_cubit.dart';
import '../../cubit/salenote_add/salenote_add_state.dart';
import '../../model/sale_note_model.dart';
import '../../model/salenote_row_form_model.dart';

class SaleNoteAdd extends StatelessWidget {
  const SaleNoteAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteAddCubit, SaleNoteAddState>(
      bloc: context.read<SaleNoteAddCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingSaleNoteAddState) {
          return saleNoteAdd(context, [], true, SaleNoteModel.empty());
        } else if (state is LoadedSaleNoteAddState) {
          return saleNoteAdd(
              context, state.rowFormList, false, SaleNoteModel.empty());
        } else {
          return saleNoteAdd(context, [], false, SaleNoteModel.empty());
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleNoteAddState) {}
      },
    );
  }

  Widget saleNoteAdd(
      BuildContext context,
      List<SaleNoteRowFormModel> rowFormList,
      bool isLoading,
      SaleNoteModel saleNote) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarGlobal(
          title: 'Nueva nota de venta',
          iconButton: null,
          iconActions: [],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationUtilities.emptyNavRailReturn(),
          const VerticalDivider(
              thickness: 1, width: 1, color: ColorPalette.darkItems),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const BtnSelectInputForm(
                                    icon: Icons.search, lblText: 'Cliente'),
                                Text(
                                    '${CustomerModel.lblPhoneNumber} ${saleNote.customer.phoneNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblRfc} ${saleNote.customer.rfc}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblStreet} ${saleNote.customer.street}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblOutNumber} ${saleNote.customer.outNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblIntNumber} ${saleNote.customer.intNumber}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblHood} ${saleNote.customer.hood}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblPostalCode} ${saleNote.customer.postalCode}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblTown} ${saleNote.customer.town}',
                                    style: Typo.labelLight),
                                Text(
                                    '${CustomerModel.lblCountry} ${saleNote.customer.country}',
                                    style: Typo.labelLight),
                              ],
                            ),
                          )),
                      const VerticalDivider(
                        color: ColorPalette.darkItems,
                        width: 1,
                        thickness: 1,
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Número: ${saleNote.id}',
                                    style: Typo.labelLight),
                                Text('Fecha: ${saleNote.date}',
                                    style: Typo.labelLight),
                                const BtnSelectInputForm(
                                    icon: Icons.search, lblText: 'Vendedor'),
                                const BtnSelectInputForm(
                                    icon: Icons.search, lblText: 'Almacén'),
                              ],
                            ),
                          )),
                    ],
                  ),
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
                                    onPressed: () {},
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
