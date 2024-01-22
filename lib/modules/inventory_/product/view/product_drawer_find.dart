import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/widgets/drawer_find.dart';
import '../cubit/product_find/product_find_cubit.dart';

class ProductDrawerFindAll extends StatelessWidget {
  const ProductDrawerFindAll({super.key});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Producto';
    return BlocBuilder<ProductFindCubit, DrawerFindState>(
      bloc: context.read<ProductFindCubit>()..load(''),
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
              context.read<ProductFindCubit>().load('');
            },
            onSubmitted: (value) {
              context.read<ProductFindCubit>().load(value);
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

class ProductDrawerFindInv extends StatelessWidget {
  const ProductDrawerFindInv({super.key});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Producto';
    return BlocBuilder<ProductFindCubit, DrawerFindState>(
      bloc: context.read<ProductFindCubit>()..load(''),
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
              context.read<ProductFindCubit>().load('');
            },
            onSubmitted: (value) {
              context.read<ProductFindCubit>().load(value);
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