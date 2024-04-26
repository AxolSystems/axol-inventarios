import 'package:axol_inventarios/utilities/widgets/appbar_axol/leading_appbar_axol.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../../user/model/user_mdoel.dart';
import '../cubit/list_details/wb_list_details_cubit.dart';
import '../cubit/list_details/wb_list_details_state.dart';
import '../cubit/wb_add/wb_add_state.dart';
import '../model/waybill_list_model.dart';
import 'wb_add_list.dart';

class WbListDetailsDrwer extends StatelessWidget {
  final WaybillListModel waybill;
  final UserModel user;
  const WbListDetailsDrwer(
      {super.key, required this.waybill, required this.user, requir});

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => WbListDetailsCubit(),
      child: WbListDetailsDrawerBuild(
        waybill: waybill,
        user: user,
        widthScreen: widthScreen,
      ),
    );
  }
}

class WbListDetailsDrawerBuild extends StatelessWidget {
  final WaybillListModel waybill;
  final UserModel user;
  final double widthScreen;
  const WbListDetailsDrawerBuild(
      {super.key,
      required this.waybill,
      required this.user,
      required this.widthScreen});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WbListDetailsCubit, WbListDetailsState>(
      bloc: context.read<WbListDetailsCubit>()..load(),
      builder: (context, state) {
        if (state is LoadingWbListDetailsState) {
          return wbLisDetailsDrawer(context, true, state.loadingState);
        } else if (state is LoadedWbListDetailsState) {
          return wbLisDetailsDrawer(context, false);
        } else {
          return wbLisDetailsDrawer(context, false);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget wbLisDetailsDrawer(BuildContext context, bool isLoading,
      [LoadingWbListDetails? loading]) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final bool editVisible;
    double totalPrice = 0;
    double totalWeight = 0;

    for (var element in waybill.list) {
      totalPrice = totalPrice +
          (element.product.price *
              element.stock *
              (element.product.weight ?? 0));
      totalWeight =
          totalWeight + (element.stock * (element.product.weight ?? 0));
    }

    if (user.rol == UserModel.rolVendor) {
      final limitTime = waybill.date.add(const Duration(hours: 24));
      if (limitTime.isAfter(DateTime.now())) {
        editVisible = true;
      } else {
        editVisible = false;
      }
    } else {
      editVisible = true;
    }
    return DrawerBox(
      width: widthScreen >= 600 ? 0.5 : 0.95,
      padding: const EdgeInsets.all(4),
      header: Container(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: ColorPalette.lightItems10),
          )),
          child: Row(
            children: [
              Visibility(
                visible: widthScreen < 600,
                child: const LeadingReturn(color: ColorPalette.darkItems),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Id',
                            style: Typo.smallLabelDark,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Almacén',
                            style: Typo.smallLabelDark,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Fecha',
                            style: Typo.smallLabelDark,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            waybill.id.toString(),
                            style: Typo.bodyDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Text(
                            waybill.warehouse.name,
                            style: Typo.bodyDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text(
                            FormatDate.dmy(waybill.date),
                            style: Typo.bodyDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
      actions: [
        Expanded(
          child: Column(
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: ColorPalette.lightItems10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Valor total: ', style: Typo.labelDark),
                          const Expanded(child: SizedBox()),
                          Text(
                            '\$ ${FormatNumber.format2dec(totalPrice)}',
                            style: Typo.labelDark,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Peso total: ', style: Typo.labelDark),
                          const Expanded(child: SizedBox()),
                          Text(
                            '${FormatNumber.format2dec(totalWeight)} KG',
                            style: Typo.labelDark,
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: SecondaryButtonDialog(
                          text: 'Descargar PDF',
                          onPressed: null,
                          loadingState: loading == LoadingWbListDetails.downPdf,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: SizedBox(
                      height: 40,
                      child: SecondaryButtonDialog(
                        text: 'Descargar CSV',
                        loadingState: loading == LoadingWbListDetails.downCsv,
                        onPressed: isLoading
                            ? null
                            : () {
                                context
                                    .read<WbListDetailsCubit>()
                                    .saveCsv(waybill.list);
                              },
                      ),
                    )),
                  ],
                ),
              ),
              Visibility(
                visible: editVisible,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: SecondaryButtonDialog(
                      text: 'Editar',
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => WbAddList(
                                    warehouse: waybill.warehouse,
                                    waybillEdit: waybill,
                                  ),
                                ),
                              ).then((value) {
                                if (value == SavedWbAdd.edit) {
                                  Navigator.pop(context, value);
                                }
                              });
                            },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: waybill.list.length,
          itemBuilder: (context, index) {
            final row = waybill.list[index];
            final totalWeight = (row.product.weight ?? 0) * row.stock;
            final totalPrice =
                row.product.price * (row.product.weight ?? 0) * row.stock;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorPalette.lightItems20))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Clave',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              row.product.code,
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descripción',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              row.product.description,
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cantidad',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              FormatNumber.format2dec(row.stock),
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Peso unitario',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              '${row.product.weight} KG',
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor unitario',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              '\$ ${row.product.price}',
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Peso total',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              '${FormatNumber.format2dec(totalWeight)} KG',
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor total',
                              style: Typo.smallLabelDark,
                            ),
                            Text(
                              '\$ ${FormatNumber.format2dec(totalPrice)}',
                              style: Typo.bodyDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
