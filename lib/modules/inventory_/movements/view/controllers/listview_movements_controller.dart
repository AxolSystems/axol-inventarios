import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/movements_view/movements_cubit.dart';
import '../../cubit/movements_view/movements_state.dart';
import '../widgets/listview_movements.dart';
import '../widgets/textfield_finder_movement.dart';
import '../widgets/toolbar_movements.dart';

/*class ListviewMovementsController extends StatelessWidget {
  const ListviewMovementsController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovementsCuibit, MovementsState>(
      bloc: context.read<MovementsCuibit>()..loadList(),
      builder: (context, state) {
        if (state is LoadingState) {
          return Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  TextfieldFinderMovement(
                    filters: state.filters,
                    isLoading: true,
                    currentFinder: state.finder,
                  ),
                  const LinearProgressIndicator(),
                  const Expanded(child: SizedBox())
                ],
              )),
              ToolbarMovements(
                isLoading: true,
                currentFilter: state.filters,
                movementsList: const [],
                mode: state.mode,
              ),
            ],
          );
        } else if (state is LoadedState) {
          return ListviewMovements(
            filters: state.filters,
            movementsList: state.movements,
            finder: state.finder,
            mode: state.mode,
          );
        }
        return Container();
      },
    );
  }
}*/
