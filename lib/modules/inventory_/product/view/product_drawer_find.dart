import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/widgets/drawer_find.dart';
import '../../inventory/model/warehouse_model.dart';
import '../cubit/product_find/product_find_cubit.dart';

class ProductDrawerFind extends StatelessWidget {
  final WarehouseModel warehouse;
  const ProductDrawerFind({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Producto';
    final List<DrawerColumn> subtitleList = [
      DrawerColumn('Id', flex: 1),
      DrawerColumn('Descripción', flex: 3),
      DrawerColumn('Stock', flex: 1),
    ];
    return BlocBuilder<ProductFindCubit, DrawerFindState>(
      bloc: context.read<ProductFindCubit>()..load('', warehouse),
      builder: (context, state) {
        if (state is LoadingDrawerFindState) {
          return DrawerFind(
            headerTable: subtitleList,
            lblText: lblText,
            listValues: const [],
            isLoading: true,
          );
        } else if (state is LoadedDrawerFindState) {
          return DrawerFind(
            headerTable: subtitleList,
            lblText: lblText,
            onPressed: () {
              context.read<FinderForm>().setForm(TextfieldFormModel.empty());
              context.read<ProductFindCubit>().load('', warehouse);
            },
            onSubmitted: (value) {
              context.read<ProductFindCubit>().load(value, warehouse);
            },
            listValues: state.valuesList,
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
