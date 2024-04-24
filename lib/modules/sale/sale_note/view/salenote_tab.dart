import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../cubit/salenote_tab/salenote_tab_cubit.dart';
import '../cubit/salenote_tab/salenote_tab_state.dart';
import '../cubit/salenote_tab/salenote_tab_form.dart';
import '../model/sale_note_model.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import 'salenote_add.dart';
import 'salenote_drawer_details.dart';

class SaleNoteTab extends StatelessWidget {
  final int saleType;
  const SaleNoteTab({super.key, required this.saleType});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SaleNoteTabCubit()),
            BlocProvider(create: (_) => SaleNoteTabForm()),
          ],
          child: SaleNoteTabBuild(
            saleType: saleType,
          ));
}

class SaleNoteTabBuild extends StatelessWidget {
  final int saleType;

  const SaleNoteTabBuild({super.key, required this.saleType});

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<SaleNoteTabForm>().state;
    return BlocBuilder<SaleNoteTabCubit, SaleNoteTabState>(
      bloc: context.read<SaleNoteTabCubit>()..initLoad(saleType, form),
      builder: (context, state) {
        if (state is LoadingSaleNoteState) {
          return saleNoteTab(context, [], true, form);
        } else if (state is LoadedSaleNoteState) {
          return saleNoteTab(context, state.salenoteList, false, form);
        } else {
          return saleNoteTab(context, [], false, form);
        }
      },
    );
  }

  Widget saleNoteTab(BuildContext context, List<SaleNoteModel> listData,
      bool isLoading, TableViewFormModel form) {
    final widthScreen = MediaQuery.of(context).size.width;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: form.finder.text,
        selection: TextSelection.collapsed(offset: form.finder.position));
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              VerticalToolBar(children: [
                Expanded(
                    child: FinderBar(
                  padding: const EdgeInsets.only(left: 12),
                  textController: textController,
                  txtForm: form.finder,
                  enabled: !isLoading,
                  autoFocus: true,
                  isTxtExpand: true,
                  onSubmitted: (value) {
                    context.read<SaleNoteTabCubit>().load(saleType, form, true);
                  },
                  onChanged: (value) {
                    form.finder = TextfieldModel(
                        text: value,
                        position: textController.selection.base.offset);
                  },
                  onPressed: () {
                    if (isLoading == false) {
                      form.finder = TextfieldModel.empty();
                      context
                          .read<SaleNoteTabForm>()
                          .setForm(TableViewFormModel.empty());
                      context
                          .read<SaleNoteTabCubit>()
                          .load(saleType, form, true);
                    }
                  },
                )),
                Visibility(
                  visible: widthScreen >= 600,
                  child: Row(
                    children: [
                      const VerticalDivider(
                        thickness: 1,
                        width: 1,
                        color: ColorPalette.lightItems10,
                        indent: 4,
                        endIndent: 4,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SaleNoteAdd(
                              saleType: saleType,
                            ),
                          ).then((value) {
                            form.finder = TextfieldModel.empty();
                            context
                                .read<SaleNoteTabCubit>()
                                .load(saleType, form, true);
                            context
                                .read<SaleNoteTabForm>()
                                .setForm(TableViewFormModel.empty());
                          });
                        },
                        icon: const Icon(
                          Icons.add_outlined,
                          color: ColorPalette.darkItems,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                decoration: BoxDecorationTheme.headerTable(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              'Clave',
                              style: Typo.subtitleLight,
                            )),
                      ),
                      Visibility(
                        visible: widthScreen >= 600,
                        child: const Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Cliente',
                                style: Typo.subtitleLight,
                              )),
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Nombre de cliente',
                              style: Typo.subtitleLight,
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              widthScreen >= 600
                                  ? 'Fecha de elaboración'
                                  : 'Fecha',
                              style: Typo.subtitleLight,
                            )),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Importe total',
                              style: Typo.subtitleLight,
                            )),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              'Almacén',
                              style: Typo.subtitleLight,
                            )),
                      ),
                      Visibility(
                        visible: widthScreen >= 600,
                        child: const Expanded(
                          flex: 2,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Vendedor',
                                style: Typo.subtitleLight,
                              )),
                        ),
                      ),
                      Visibility(
                        visible: widthScreen >= 600,
                        child: const Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Estado',
                                style: Typo.subtitleLight,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Column(
                        children: [
                          LinearProgressIndicatorAxol(),
                          Expanded(child: SizedBox())
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          final saleNoteRow = listData[index];
                          final String status;
                          if (saleNoteRow.status == 0) {
                            status = 'Cancelado';
                          } else if (saleNoteRow.status == 1) {
                            status = 'Emitido';
                          } else {
                            status = '';
                          }
                          return Container(
                            height: 30,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white12),
                              ),
                            ),
                            child: ButtonRowTable(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => SaleNoteDrawerDetails(
                                          saleNote: saleNoteRow,
                                          saleType: saleType,
                                        )).then((value) {
                                  form.finder = TextfieldModel.empty();
                                  context
                                      .read<SaleNoteTabCubit>()
                                      .load(saleType, form, true);
                                  context
                                      .read<SaleNoteTabForm>()
                                      .setForm(TableViewFormModel.empty());
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    //1) Clave
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Text(
                                        saleNoteRow.id.toString(),
                                        style: Typo.labelText1,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widthScreen >= 600,
                                    child: Expanded(
                                      // 2) Cliente
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          saleNoteRow.customer.id.toString(),
                                          style: Typo.labelText1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // 3) Nombre de cliente
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        saleNoteRow.customer.name,
                                        style: Typo.labelText1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // 4) Fecha de elaboración
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        FormatDate.dmy(saleNoteRow.date),
                                        style: Typo.labelText1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // 5) Importe total
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        '\$ ${FormatNumber.format2dec(saleNoteRow.total)}',
                                        style: Typo.labelText1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // 6) Almacen
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Text(
                                        saleNoteRow.warehouse.id.toString(),
                                        style: Typo.labelText1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widthScreen >= 600,
                                    child: Expanded(
                                      // 7) Vendedor
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          saleNoteRow.vendor.name,
                                          style: Typo.labelText1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widthScreen >= 600,
                                    child: Expanded(
                                      // 8) Estado
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          status,
                                          style: Typo.labelText1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              NavigateBarTable(
                currentPage: form.currentPage,
                limitPaga: form.limitPage,
                totalReg: form.totalReg,
                onPressedLeft: () {
                  if (form.currentPage > 1) {
                    form.currentPage = form.currentPage - 1;
                    context
                        .read<SaleNoteTabCubit>()
                        .load(saleType, form, false);
                  }
                },
                onPressedRight: () {
                  if (form.currentPage < form.limitPage) {
                    form.currentPage = form.currentPage + 1;
                    context
                        .read<SaleNoteTabCubit>()
                        .load(saleType, form, false);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
