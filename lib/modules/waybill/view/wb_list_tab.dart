import 'package:axol_inventarios/modules/waybill/cubit/wb_list/wb_list_state.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/table_view/table_view.dart';
import '../cubit/wb_list/wb_list_cubit.dart';
import '../model/wb_list_form_model.dart';
import 'wb_list_details_bottomsheet.dart';
import 'wb_list_details_drawer.dart';

class WbListTab extends StatelessWidget {
  const WbListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbListCubit()),
        BlocProvider(create: (_) => WbListForm()),
      ],
      child: const WbWarehouseTabBuild(),
    );
  }
}

class WbWarehouseTabBuild extends StatelessWidget {
  const WbWarehouseTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    WbListFormModel form = context.read<WbListForm>().state;
    return BlocConsumer<WbListCubit, WbListState>(
      bloc: context.read<WbListCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingWbListState) {
          return wbListTab(context, true, form);
        } else if (state is LoadedWbListState) {
          return wbListTab(context, false, form);
        } else {
          return wbListTab(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorWbListState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
        if (state is OpenDetailsWbListState) {
          if (widthScreen < 600) {
            showModalBottomSheet(
              backgroundColor: ColorPalette.lightBackground,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12))),
              context: context,
              builder: (context) => WbListDetailsBottomsheet(
                waybill: state.waybillList,
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) => WbListDetailsDrawer(
                      waybill: state.waybillList,
                    ));
          }
        }
      },
    );
  }

  Widget wbListTab(BuildContext context, bool isLoading, WbListFormModel form) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: isLoading,
          replacement: const SizedBox(height: 4),
          child: const LinearProgressIndicatorAxol(),
        ),
        Expanded(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: form.waybillList.length,
          itemBuilder: (context, index) {
            final waybill = form.waybillList[index];

            return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorPalette.darkItems),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          waybill.id.toString(),
                          style: Typo.bodyLight,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          FormatDate.dmy(waybill.date),
                          style: Typo.bodyLight,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          waybill.warehouse.name,
                          style: Typo.bodyLight,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: () {
                          context.read<WbListCubit>().saveCsv(waybill.id);
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_outward,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: () {
                          context.read<WbListCubit>().openDetails(waybill);
                        },
                      ),
                    ],
                  ),
                ));
          },
        )),
        NavigateBarTable(
          currentPage: form.currentPage,
          limitPaga: form.totalPages,
          totalReg: form.totalReg,
          onPressedLeft: () {
            if (form.currentPage > 1) {
              form.currentPage = form.currentPage - 1;
              context.read<WbListCubit>().load(form);
            }
          },
          onPressedRight: () {
            if (form.currentPage < form.totalPages) {
              form.currentPage = form.currentPage + 1;
              context.read<WbListCubit>().load(form);
            }
          },
        ),
      ],
    );
  }
}
