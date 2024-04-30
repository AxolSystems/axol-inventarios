import 'package:axol_inventarios/modules/sale_report/view/srp_details_doc_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../utilities/widgets/table_view/table_view.dart';
import '../cubit/add/srp_add_state.dart';
import '../cubit/doclist_tab/srp_doclist_tab_cubit.dart';
import '../cubit/doclist_tab/srp_doclist_tab_state.dart';
import '../model/srp_doclist_form_model.dart';
import 'srp_details_doc_bottomsheet.dart';

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
        if (state is OpenDetailsSrpDoclistState) {
          final user = state.user;
          showDialog(
              context: context,
              builder: (context) => SrpDetailsDocDrawer(
                    saleReport: state.saleReport,
                    user: user,
                  )).then((value) {
            if (value == SrpAddSubState.edit) {
              context.read<SrpDoclistCubit>().initLoad(form);
            }
          });
        }
      },
    );
  }

  Widget sroDoclistTab(
      BuildContext context, bool isLoading, SrpDoclistFormModel form) {
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
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  onPressed: () {
                    context.read<SrpDoclistCubit>().openDetails(saleReport);
                  },
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
                        const Icon(Icons.navigate_next,
                            color: ColorPalette.lightItems10),
                      ],
                    ),
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
