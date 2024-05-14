import 'package:axol_inventarios/modules/inventory_/movements/view/movement_drawer_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../cubit/movement_tab/movement_tab_cubit.dart';
import '../cubit/movement_tab/movement_tab_state.dart';
import '../model/movement_filter_model.dart';
import '../model/movement_model.dart';
import 'movement_drawer_file.dart';

class MovementTab extends StatelessWidget {
  const MovementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovementTabCubit()),
        BlocProvider(create: (_) => TableViewFormCubit()),
      ],
      child: const MovementTabBuild(),
    );
  }
}

class MovementTabBuild extends StatelessWidget {
  const MovementTabBuild({super.key});

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<TableViewFormCubit>().state;
    return BlocConsumer<MovementTabCubit, MovementTabState>(
      bloc: context.read<MovementTabCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingMovementTabState) {
          return movementTab(context, form, true, []);
        } else if (state is LoadedMovementTabState) {
          return movementTab(context, form, false, state.movementList);
        } else {
          return movementTab(context, form, false, []);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget movementTab(BuildContext context, TableViewFormModel form,
      bool isLoading, List<MovementModel> movementList) {
    final widthScreen = MediaQuery.of(context).size.width;
    TextEditingController textController = TextEditingController.fromValue(
        TextEditingValue(
            text: form.finder.text,
            selection: TextSelection.collapsed(offset: form.finder.position)));
    List<List<DataTableAxol>> rowList = [];
    List<DataTableAxol> row = [];
    List<DataTableAxol> headList = [];

    if (widthScreen >= 600) {
      for (var movement in movementList) {
        row = [];
        row.add(DataTableAxol.text(movement.folio.toString()));
        row.add(DataTableAxol.text(movement.warehouseName));
        row.add(DataTableAxol.text(movement.document));
        row.add(DataTableAxol.text(movement.code));
        row.add(DataTableAxol.text(movement.description));
        row.add(DataTableAxol.text(movement.concept.toString()));
        row.add(DataTableAxol.text(FormatDate.dmy(movement.time)));
        row.add(DataTableAxol.text(movement.quantity.toString()));
        row.add(DataTableAxol.text(movement.stock.toString()));
        rowList.add(row);
        headList = [
            DataTableAxol.text(MovementModel.lblFolio),
            DataTableAxol.text(MovementModel.lblWarehouse),
            DataTableAxol.text(MovementModel.lblDocument),
            DataTableAxol.text(MovementModel.lblCode),
            DataTableAxol.text(MovementModel.lblDescription),
            DataTableAxol.text(MovementModel.lblConcept),
            DataTableAxol.text(MovementModel.lblTime),
            DataTableAxol.text(MovementModel.lblQuantity),
            DataTableAxol.text(MovementModel.lblStock),
          ];
      }
    } else {
      for (var movement in movementList) {
        row = [];
        row.add(DataTableAxol.text(movement.warehouseId.toString()));
        row.add(DataTableAxol.text(movement.document));
        row.add(DataTableAxol.text(movement.code));
        row.add(DataTableAxol(flex: 2, text: FormatDate.dmy(movement.time)));
        row.add(DataTableAxol.text(movement.quantity.toString()));
        row.add(DataTableAxol.text(movement.stock.toString()));
        rowList.add(row);
      headList = [
            DataTableAxol.text(MovementModel.lblWarehouse),
            DataTableAxol.text(MovementModel.lblDocument),
            DataTableAxol.text(MovementModel.lblCode),
            DataTableAxol(flex: 2, text: MovementModel.lblTime),
            DataTableAxol.text(MovementModel.lblQuantity),
            DataTableAxol.text(MovementModel.lblStock),
          ];
      }
    }

    return Column(
      children: [
        VerticalToolBar(
          children: [
            Expanded(
                child: FinderBar(
              padding: const EdgeInsets.only(left: 12),
              textController: textController,
              txtForm: form.finder,
              enabled: !isLoading,
              autoFocus: true,
              isTxtExpand: true,
              onSubmitted: (value) {
                form.currentPage = 1;
                context.read<MovementTabCubit>().load(form);
              },
              onChanged: (value) {
                form.finder = TextfieldModel(
                    text: value,
                    position: textController.selection.base.offset);
              },
              onPressed: () {
                if (isLoading == false) {
                  form.finder = TextfieldModel.empty();
                  context.read<MovementTabCubit>().load(form);
                }
              },
            )),
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
                  builder: (context) => MovementDrawerFilter(
                    filter: form.filter,
                  ),
                ).then((value) {
                  if (value is MovementFilterModel) {
                    form.filter = MovementFilterModel.filterToMap(value);
                    form.currentPage = 1;
                    context.read<MovementTabCubit>().load(form);
                  }
                });
              },
              icon: const Icon(
                Icons.filter_alt,
                color: ColorPalette.darkItems20,
                size: 30,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      MovementDrawerFile(movementList: movementList),
                );
              },
              icon: const Icon(
                Icons.download,
                color: ColorPalette.darkItems20,
                size: 30,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context.read<MovementTabCubit>().downloadCsv(movementList);
              },
              icon: const Icon(
                Icons.backup_table_rounded,
                color: ColorPalette.darkItems20,
                size: 30,
              ),
            ),
          ],
        ),
        HeaderTable(
          dataList: headList,
        ),
        ListViewTable(
          isLoading: isLoading,
          rowList: rowList,
          dataList: movementList,
        ),
        NavigateBarTable(
          currentPage: form.currentPage,
          limitPaga: form.limitPage,
          totalReg: form.totalReg,
          onPressedLeft: () {
            if (form.currentPage > 1) {
              form.currentPage = form.currentPage - 1;
              context.read<MovementTabCubit>().load(form);
            }
          },
          onPressedRight: () {
            if (form.currentPage < form.limitPage) {
              form.currentPage = form.currentPage + 1;
              context.read<MovementTabCubit>().load(form);
            }
          },
        ),
      ],
    );
  }
}
