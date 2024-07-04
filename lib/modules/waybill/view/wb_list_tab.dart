import 'package:axol_inventarios/modules/waybill/cubit/wb_list/wb_list_state.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/table_view/table_view.dart';
import '../cubit/wb_add/wb_add_state.dart';
import '../cubit/wb_list/wb_list_cubit.dart';
import '../model/wb_list_form_model.dart';
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
            showDialog(
              context: context,
              builder: (context) => WbListDetailsDrwer(
                waybill: state.waybillList,
                user: state.user,
              ),
            ).then((value) {
              if (value == SavedWbAdd.edit) {
                context.read<WbListCubit>().initLoad(form);
              }
            });
          
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

            return OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide.none, padding: const EdgeInsets.all(0)),
                onPressed: () {
                  context.read<WbListCubit>().openDetails(waybill);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ColorPalette.darkItems20),
                    ),
                  ),
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
                      const Icon(Icons.navigate_next,
                          color: ColorPalette.lightItems10),
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
