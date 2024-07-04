import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/theme/theme.dart';
import '../../cubit/rc_details_cubit/rc_details_cubit.dart';
import '../../cubit/rc_details_cubit/rc_details_state.dart';
import '../../model/routcustomer_model.dart';
import '../widgets/drawer_details_rc.dart';

class DrawerDetailsRcController extends StatelessWidget {
  final RoutcustomerModel rc;

  const DrawerDetailsRcController({super.key, required this.rc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RcDetailsCubit, RcDetailsState>(
      bloc: context.read<RcDetailsCubit>()..initial(rc),
      builder: (context, state) {
        if (state is LoadingState) {
          // ignore: prefer_const_constructors
          return DrawerDetailsRc(
            isLoading: true,
            rc: rc,
            isValid: state.isValid,
          );
        } else if (state is LoadedState) {
          // ignore: prefer_const_constructors
          return DrawerDetailsRc(
            isLoading: false,
            rc: rc,
            isValid: state.isValid,
          );
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: Typo.labelText1,
          );
        }
        return const Text(
          'No emitio nada...',
          style: Typo.labelText1,
        );
      },
    );
  }
}