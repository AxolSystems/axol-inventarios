import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/movement_filters/movement_filters_cubit.dart';
import '../../cubit/movement_filters/movement_filters_state.dart';
import '../../model/movement_filter_model.dart';
import '../widgets/drawer_history.dart';

/*class DrawerHistoryController extends StatelessWidget {
  final MovementFilterModel currentFilter;

  const DrawerHistoryController({super.key, required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          color: Colors.black26,
        )),
        Drawer(
          width: 500,
          child: BlocBuilder<MovementFiltersCubit, MovementFiltersState>(
            bloc: context.read<MovementFiltersCubit>()
              ..getInitialValues(currentFilter),
            builder: (context, state) {
              if (state is LoadingState) {
                return const Column(
                  children: [
                    LinearProgressIndicator(),
                    Expanded(child: SizedBox())
                  ],
                );
              } else if (state is LoadedState) {
                return DrawerHistory(
                  filters: state.movementFilters,
                );
              } else if (state is ErrorState) {
                return Text(state.error);
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}*/
