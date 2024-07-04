import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/routcustomer cubit/routcustomer_cubit.dart';
import '../../cubit/routcustomer cubit/routcustomer_state.dart';
import '../widgets/finder_rc.dart';
import '../widgets/listview_rc.dart';
import '../widgets/toolbar_rc.dart';

class ListviewRcController extends StatelessWidget {
  const ListviewRcController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutcustomerCubit, RoutcustomerState>(
      bloc: context.read<RoutcustomerCubit>()..load(TextfieldModel.empty()),
      builder: (context, state) {
        if (state is LoadingState) {
          return Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  FinderRc(
                    isLoading: true,
                    currentFinder: state.textfieldFinder,
                  ),
                  const LinearProgressIndicator(),
                  const Expanded(child: SizedBox())
                ],
              )),
              const ToolbarRc(
                isLoading: true,
              ),
            ],
          );
        } else if (state is LoadedState) {
          return ListviewRc(
            listData: state.rcList,
            finder: state.textfieldFinder,
          );
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: Typo.labelText1,
          );
        }
        return Container();
      },
    );
  }
}
