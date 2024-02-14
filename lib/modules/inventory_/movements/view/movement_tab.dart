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
import '../model/movement_model.dart';

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
    TextEditingController textController = TextEditingController.fromValue(
        TextEditingValue(
            text: form.finder.text,
            selection: TextSelection.collapsed(offset: form.finder.position)));
    List<List<DataTableAxol>> rowList = [];
    List<DataTableAxol> row = [];
    for (var movement in movementList) {
      row = [];
      row.add(DataTableAxol.text(movement.folio.toString()));
      row.add(DataTableAxol.text(movement.warehouse));
      row.add(DataTableAxol.text(movement.document));
      row.add(DataTableAxol.text(movement.code));
      row.add(DataTableAxol.text(movement.description));
      row.add(DataTableAxol.text(movement.concept.toString()));
      row.add(DataTableAxol.text(FormatDate.dmy(movement.time)));
      row.add(DataTableAxol.text(movement.quantity.toString()));
      row.add(DataTableAxol.text(movement.stock.toString()));
      rowList.add(row);
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
              color: ColorPalette.lightItems,
              indent: 4,
              endIndent: 4,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt,
                color: ColorPalette.darkItems,
                size: 30,
              ),
            ),
          ],
        ),
        HeaderTable(
          dataList: [
            DataTableAxol.text(MovementModel.lblFolio),
            DataTableAxol.text(MovementModel.lblWarehouse),
            DataTableAxol.text(MovementModel.lblDocument),
            DataTableAxol.text(MovementModel.lblCode),
            DataTableAxol.text(MovementModel.lblDescription),
            DataTableAxol.text(MovementModel.lblConcept),
            DataTableAxol.text(MovementModel.lblTime),
            DataTableAxol.text(MovementModel.lblQuantity),
            DataTableAxol.text(MovementModel.lblStock),
          ],
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
