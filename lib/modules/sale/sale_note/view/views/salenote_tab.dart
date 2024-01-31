import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../../../../utilities/widgets/button.dart';
import '../../../../../utilities/widgets/finder_bar.dart';
import '../../../../../utilities/widgets/providers.dart';
import '../../../../../utilities/widgets/toolbar.dart';
import '../../cubit/salenote_tab/salenote_tab_cubit.dart';
import '../../cubit/salenote_tab/salenote_tab_state.dart';
import '../../cubit/salenote_tab/salenote_tab_form.dart';
import '../../model/sale_note_model.dart';
import 'salenote_drawer_details.dart';

class SaleNoteTab extends StatelessWidget {
  const SaleNoteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleNoteTabCubit, SaleNoteTabState>(
      bloc: context.read<SaleNoteTabCubit>()..loadList(),
      builder: (context, state) {
        if (state is LoadingSaleNoteState) {
          return saleNoteTab(context, [], true);
        } else if (state is LoadedSaleNoteState) {
          return saleNoteTab(context, state.salenoteList, false);
        } else {
          return saleNoteTab(context, [], false);
        }
      },
    );
  }

  Widget saleNoteTab(
      BuildContext context, List<SaleNoteModel> listData, bool isLoading) {
    TextfieldModel form = context.read<SaleNoteTabForm>().state;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: form.text,
        selection: TextSelection.collapsed(offset: form.position));
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
                  txtForm: form,
                  enabled: !isLoading,
                  autoFocus: true,
                  isTxtExpand: true,
                  onSubmitted: (value) {
                    context.read<SaleNoteTabCubit>().load(value);
                  },
                  onChanged: (value) {
                    form = TextfieldModel(
                        text: value,
                        position: textController.selection.base.offset);
                    context.read<SaleNoteTabForm>().setForm(form);
                  },
                  onPressed: () {
                    if (isLoading == false) {
                      context
                          .read<SaleNoteTabForm>()
                          .setForm(TextfieldModel.empty());
                      context.read<SaleNoteTabCubit>().load('');
                    }
                  },
                )),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: ColorPalette.lightItems,
                  indent: 4,
                  endIndent: 4,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ProviderSaleNoteAdd(),
                    ).then((value) {
                      context.read<SaleNoteTabCubit>().load('');
                      context
                          .read<SaleNoteTabForm>()
                          .setForm(TextfieldModel.empty());
                    });
                  },
                  icon: const Icon(
                    Icons.add_outlined,
                    color: ColorPalette.darkItems,
                    size: 30,
                  ),
                ),
              ]),
              Container(
                decoration: BoxDecorationTheme.headerTable(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Clave',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Cliente',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Nombre de cliente',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Fecha de elaboración',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Importe total',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Almacén',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Vendedor',
                          style: Typo.subtitleLight,
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          'Estado',
                          style: Typo.subtitleLight,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
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
                                  saleNote: saleNoteRow)).then((value) {
                            context.read<SaleNoteTabCubit>().load('');
                            context
                                .read<SaleNoteTabForm>()
                                .setForm(TextfieldModel.empty());
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              //1) Clave
                              flex: 1,
                              child: Center(
                                child: Text(
                                  saleNoteRow.id.toString(),
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 2) Cliente
                              flex: 1,
                              child: Center(
                                child: Text(
                                  saleNoteRow.customer.id.toString(),
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 3) Nombre de cliente
                              flex: 1,
                              child: Center(
                                child: Text(
                                  saleNoteRow.customer.name,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 4) Fecha de elaboración
                              flex: 1,
                              child: Center(
                                child: Text(
                                  '${saleNoteRow.date.day}/${saleNoteRow.date.month}/${saleNoteRow.date.year}',
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 5) Importe total
                              flex: 1,
                              child: Center(
                                child: Text(
                                  '\$${saleNoteRow.total}',
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 6) Almacen
                              flex: 1,
                              child: Center(
                                child: Text(
                                  saleNoteRow.warehouse.id.toString(),
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 7) Vendedor
                              flex: 1,
                              child: Center(
                                child: Text(
                                  saleNoteRow.vendor.name,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 8) Estado
                              flex: 1,
                              child: Center(
                                child: Text(
                                  status,
                                  style: Typo.labelText1,
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
            ],
          ),
        ),
      ],
    );
  }
}
