import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../utilities/widgets/table_view/table_view.dart';
import '../cubit/doclist_tab/srp_doclist_tab_cubit.dart';
import '../cubit/doclist_tab/srp_doclist_tab_state.dart';
import '../model/srp_doclist_form_model.dart';

class SrpDoclistTab extends StatelessWidget {
  const SrpDoclistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SrpDoclistCubit()),
        BlocProvider(create: (_) => SrpDoclistForm()),
      ],
      child: const SrpDoclistTabBuild(),
    );
  }
}

class SrpDoclistTabBuild extends StatelessWidget {
  const SrpDoclistTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    SrpDoclistFormModel form = context.read<SrpDoclistForm>().state;
    return BlocConsumer<SrpDoclistCubit, SrpDoclistState>(
      bloc: context.read<SrpDoclistCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingSrpDoclistState) {
          return sroDoclistTab(context, true, form);
        } else if (state is LoadedSrpDoclistState) {
          return sroDoclistTab(context, false, form);
        } else {
          return sroDoclistTab(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorSrpDoclistState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
        /*if (state is OpenDetailsSrpDoclistState) {
          if (widthScreen < 600) {
            showModalBottomSheet(
              backgroundColor: ColorPalette.lightBackground,
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
        }*/
      },
    );
  }

  Widget sroDoclistTab(BuildContext context, bool isLoading, SrpDoclistFormModel form) {
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
          itemCount: form.saleReportList.length,
          itemBuilder: (context, index) {
            final saleReport = form.saleReportList[index];

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
                          saleReport.id.toString(),
                          style: Typo.bodyLight,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          FormatDate.dmy(saleReport.date),
                          style: Typo.bodyLight,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          saleReport.warehouse.name,
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
                          context.read<SrpDoclistCubit>().saveCsv(saleReport);
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_outward,
                          color: ColorPalette.lightItems10,
                        ),
                        onPressed: () {
                          //context.read<SrpDoclistCubit>().openDetails(saleReport);
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
              context.read<SrpDoclistCubit>().load(form);
            }
          },
          onPressedRight: () {
            if (form.currentPage < form.totalPages) {
              form.currentPage = form.currentPage + 1;
              context.read<SrpDoclistCubit>().load(form);
            }
          },
        ),
      ],
    );
  }
}