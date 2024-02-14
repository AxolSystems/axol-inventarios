import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/table_view/table_view.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../../../../utilities/widgets/toolbar.dart';
import '../cubit/movement_tab/movement_tab_cubit.dart';
import '../cubit/movement_tab/movement_tab_state.dart';
import '../model/movement_model.dart';

class MovementsTab extends StatelessWidget {
  const MovementsTab({super.key});

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
      builder: (context, state) {
        if (state is LoadingMovementTabState) {
          return movementTab(context, form, true);
        } else if (state is LoadedMovementTabState) {
          return movementTab(context, form, false);
        } else {
          return movementTab(context, form, false);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget movementTab(
      BuildContext context, TableViewFormModel form, bool isLoading) {
    TextEditingController textController = TextEditingController.fromValue(
        TextEditingValue(
            text: form.finder.text,
            selection: TextSelection.collapsed(offset: form.finder.position)));
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
                Icons.add_outlined,
                color: ColorPalette.darkItems,
                size: 30,
              ),
            ),
          ],
        ),
        HeaderTable(
          dataList: [
            DataHeadTable.text(MovementModel.lblFolio),
            DataHeadTable.text(MovementModel.lblWarehouse),
            DataHeadTable.text(MovementModel.lblDocument),
            DataHeadTable.text(MovementModel.lblCode),
            DataHeadTable.text(MovementModel.lblDescription),
            DataHeadTable.text(MovementModel.lblConcept),
            DataHeadTable.text(MovementModel.lblTime),
            DataHeadTable.text(MovementModel.lblQuantity),
            DataHeadTable.text(MovementModel.lblStock),
          ],
        )
      ],
    );
  }
}
