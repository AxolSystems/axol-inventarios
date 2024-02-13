import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../cubit/movement_tab/movement_tab_cubit.dart';

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
    // TODO: implement build
    throw UnimplementedError();
  }

}