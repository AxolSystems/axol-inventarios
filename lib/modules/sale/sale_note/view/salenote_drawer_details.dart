import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/shimmer_indicator.dart';
import '../../customer/model/customer_model.dart';
import '../cubit/salenote_details/salenote_details_cubit.dart';
import '../cubit/salenote_details/salenote_details_state.dart';
import '../model/sale_note_model.dart';
import '../model/sale_product_model.dart';
import 'salenote_dialog_cancel.dart';

class SaleNoteDrawerDetails extends StatelessWidget {
  final int saleType;
  final SaleNoteModel saleNote;
  const SaleNoteDrawerDetails(
      {super.key, required this.saleNote, required this.saleType});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SaleNoteDetailsCubit()),
          ],
          child: SaleNoteDrawerDetailsBuild(
            saleNote: saleNote,
            saleType: saleType,
          ));
}

class SaleNoteDrawerDetailsBuild extends StatelessWidget {
  final SaleNoteModel saleNote;
  final int saleType;
  const SaleNoteDrawerDetailsBuild(
      {super.key, required this.saleNote, required this.saleType});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleNoteDetailsCubit, SaleNoteDetailsState>(
      bloc: context.read<SaleNoteDetailsCubit>()..load(saleNote.saleProduct),
      builder: (context, state) {
        if (state is LoadingSaleNoteDetailsState) {
          return saleNoteDrawerDetails(context, true);
        } else if (state is LoadedSaleNoteDetailsState) {
          return saleNoteDrawerDetails(context, false,
              upProductList: state.productList);
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

  Widget saleNoteDrawerDetails(BuildContext context, bool isLoading,
      {List<SaleProductModel>? upProductList}) {
    String title = '';
    List<SaleProductModel> upProductList_ = upProductList ?? [];
    List<Widget> productList = [];
    Widget product;
    for (SaleProductModel element in upProductList_) {
      product = DrawerBox.rowValues([
        DrawerCellText(element.product.code, style: Typo.bodyDark),
        DrawerCellText(element.quantity.toString(), style: Typo.bodyDark),
        DrawerCellText(element.price.toString(), style: Typo.bodyDark),
      ]);
      productList.add(product);
    }

    if (saleType == 0) {
      title = 'Nota de venta';
    }
    if (saleType == 1) {
      title = 'Remisión';
    }

    return DrawerBox(
      header: Text(
        title,
        style: Typo.subtitleDark,
      ),
      actions: [
        Visibility(
            visible: saleNote.status == 1,
            child: AlertButtonDialog(
              text: 'Cancelar',
              isLoading: isLoading,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SaleNoteDialogCancel(
                          saleNote: saleNote,
                          saleType: saleType,
                        ));
              },
            )),
        SecondaryButtonDialog(
          text: 'Descargar PDF',
          isLoading: isLoading,
          onPressed: () {
            context
                .read<SaleNoteDetailsCubit>()
                .downloadPdf(saleNote, upProductList_, saleType);
          },
        ),
        SecondaryButtonDialog(
          isLoading: isLoading,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        DrawerBox.rowKeyValue('Folio: ', saleNote.id.toString()),
        DrawerBox.rowKeyValue('Fecha: ', FormatDate.dmy(saleNote.date)),
        DrawerBox.rowKeyValue(
            'Vendedor: ', '${saleNote.vendor.id} - ${saleNote.vendor.name}'),
        DrawerBox.rowKeyValue('Almacén: ',
            '${saleNote.warehouse.id} - ${saleNote.warehouse.name}'),
        const Divider(
          color: ColorPalette.lightItems10,
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
        ], color: ColorPalette.lightItems10),
        Column(
          children: isLoading
              ? [
                  Row(
                    children: [
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                    ],
                  ),
                  Row(
                    children: [
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                    ],
                  ),
                  Row(
                    children: [
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                      ShimmerIndicator.horizontalExpanded(height: 15),
                    ],
                  ),
                ]
              : productList,
        ),
      ],
    );
  }
}
