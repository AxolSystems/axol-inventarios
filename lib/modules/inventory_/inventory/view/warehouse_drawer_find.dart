import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_form_model.dart';
import '../../../../../utilities/widgets/drawer_find.dart';
import '../cubit/warehouse_find/warehouse_find_cubit.dart';

class WarehouseDrawerFind extends StatelessWidget {
  const WarehouseDrawerFind({super.key});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Almacén';
    return BlocBuilder<WarehouseFindCubit, DrawerFindState>(
      bloc: context.read<WarehouseFindCubit>()..load(''),
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
            onPressed: () {
              context.read<FinderForm>().setForm(TextfieldFormModel.empty());
              context.read<WarehouseFindCubit>().load('');
            },
            onSubmitted: (value) {
              context.read<WarehouseFindCubit>().load(value);
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
