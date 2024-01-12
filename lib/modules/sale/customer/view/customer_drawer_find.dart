import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/drawer_find.dart';
import '../cubit/customer_find/customer_find_cubit.dart';

class CustomerDrawerFind extends StatelessWidget {
  const CustomerDrawerFind({super.key});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Cliente';
    return BlocBuilder<CustomerFindCubit, DrawerFindState>(
      bloc: context.read<CustomerFindCubit>()..load(''),
      builder: (context, state) {
        if (state is LoadingDrawerFindState) {
          return const DrawerFind(
            lblText: lblText,
            listData: [],
            isLoading: true,
          );
        } else if (state is LoadedDrawerFindState) {
          return DrawerFind(
            lblText: lblText,
            onPressed: () {},
            onSubmitted: (value) {
              context.read<CustomerFindCubit>().load(value);
            },
            listData: state.dataList,
          );
        } else {
          return const DrawerFind(
            lblText: lblText,
            listData: [],
          );
        }
      },
    );
  }
}
