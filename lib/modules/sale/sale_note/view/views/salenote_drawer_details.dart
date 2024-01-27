import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/format.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/button.dart';
import '../../../../../utilities/widgets/drawer_box.dart';
import '../../../customer/model/customer_model.dart';
import '../../cubit/salenote_details/salenote_details_cubit.dart';
import '../../cubit/salenote_details/salenote_details_state.dart';
import '../../model/sale_note_model.dart';
import '../../model/sale_product_model.dart';

class SaleNoteDrawerDetails extends StatelessWidget {
  final SaleNoteModel saleNote;
  const SaleNoteDrawerDetails({super.key, required this.saleNote});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => SaleNoteDetailsCubit()),
      ], child: blocBuilder(context));

  Widget blocBuilder(BuildContext context) {
    return BlocConsumer<SaleNoteDetailsCubit, SaleNoteDetailsState>(
      bloc: context.read<SaleNoteDetailsCubit>()..load(''),
      builder: (context, state) {
        if (state is LoadingSaleNoteDetailsState) {
          return saleNoteDrawerDetails(context, true);
        } else if (state is LoadedSaleNoteDetailsState) {
          return saleNoteDrawerDetails(context, false);
        } else {
          return saleNoteDrawerDetails(context, false);
        }
      },
      listener: (context, state) {
        if (state is ErrorSaleNoteDetailsState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget saleNoteDrawerDetails(BuildContext context, bool isLoading) {
    List<Widget> productList = [];
    Widget product;
    //Widget test;
    for (SaleProductModel element in saleNote.saleProduct) {
      product = DrawerBox.rowValues([
        DrawerCellText(element.product.code, style: Typo.bodyDark),
        DrawerCellText(element.quantity.toString(), style: Typo.bodyDark),
        DrawerCellText(element.price.toString(), style: Typo.bodyDark),
      ]);
      productList.add(product);
    }
    /*test = DrawerBox.rowValues([
      const DrawerCellText('Clave1', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
    ]);
    productList.add(test);
    test = DrawerBox.rowValues([
      const DrawerCellText('Clave2', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
    ]);
    productList.add(test);
    test = DrawerBox.rowValues([
      const DrawerCellText('Clave3', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
      const DrawerCellText('0', style: Typo.bodyDark),
    ]);
    productList.add(test);*/
    return DrawerBox(
      header: const Text(
        'Nota de venta',
        style: Typo.subtitleDark,
      ),
      actions: [
        ButtonReturnDialog(
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      children: [
        DrawerBox.rowKeyValue('Folio: ', saleNote.id.toString()),
        DrawerBox.rowKeyValue('Fecha: ', FormatDate.dmy(saleNote.date)),
        DrawerBox.rowKeyValue(
            'Vendedor: ', '${saleNote.vendor.id} - ${saleNote.vendor.name}'),
        DrawerBox.rowKeyValue('Almacén: ',
            '${saleNote.warehouse.id} - ${saleNote.warehouse.name}'),
        const Divider(
          color: ColorPalette.lightItems,
          height: 16,
          thickness: 1,
        ),
        DrawerBox.rowKeyValue('Cliente : ',
            '${saleNote.customer.id} - ${saleNote.customer.name}'),
        DrawerBox.rowKeyValue(CustomerModel.lblPhoneNumber,
            '${saleNote.customer.phoneNumber ?? ''}'),
        DrawerBox.rowKeyValue(
            CustomerModel.lblRfc, saleNote.customer.rfc ?? ''),
        DrawerBox.rowKeyValue(
            CustomerModel.lblPostalCode, saleNote.customer.postalCode ?? ''),
        DrawerBox.rowKeyValue(CustomerModel.lblIntNumber,
            '${saleNote.customer.phoneNumber ?? ''}'),
        DrawerBox.rowKeyValue(
            CustomerModel.lblOutNumber, '${saleNote.customer.outNumber ?? ''}'),
        DrawerBox.rowKeyValue(
            CustomerModel.lblStreet, saleNote.customer.street ?? ''),
        DrawerBox.rowKeyValue(
            CustomerModel.lblHood, saleNote.customer.hood ?? ''),
        DrawerBox.rowKeyValue(
            CustomerModel.lblTown, saleNote.customer.town ?? ''),
        DrawerBox.rowKeyValue(
            CustomerModel.lblCountry, saleNote.customer.country ?? ''),
        DrawerBox.headTable([
          const DrawerCellText('Clave', style: Typo.subtitleDark),
          const DrawerCellText('Canitdad', style: Typo.subtitleDark),
          const DrawerCellText('Importe', style: Typo.subtitleDark),
        ], color: ColorPalette.lightItems),
        Column(
          children: productList,
        ),
      ],
    );
  }
}
