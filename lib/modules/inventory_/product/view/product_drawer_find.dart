import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/data_find.dart';
import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/drawer_find.dart';
import '../../inventory/model/warehouse_model.dart';
import '../cubit/product_find/product_find_cubit.dart';

class ProductDrawerFind extends StatelessWidget {
  final WarehouseModel warehouse;
  const ProductDrawerFind({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ProductFindCubit()),
            BlocProvider(create: (_) => FinderForm()),
          ],
          child: ProductDrawerFindBuild(
            warehouse: warehouse,
          ));
}

class ProductDrawerFindBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const ProductDrawerFindBuild({super.key, required this.warehouse});

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
          return productDrawerFind(
            context: context,
            isLoading: true,
            subtitleList: subtitleList,
            lblText: lblText,
          );
        } else if (state is LoadedDrawerFindState) {
          return productDrawerFind(
              context: context,
              isLoading: false,
              subtitleList: subtitleList,
              lblText: lblText,
              listValues: state.valuesList);
        } else {
          return productDrawerFind(
            context: context,
            isLoading: false,
            subtitleList: subtitleList,
            lblText: lblText,
          );
        }
      },
    );
  }

  Widget productDrawerFind({
    required BuildContext context,
    required bool isLoading,
    required List<DrawerColumn> subtitleList,
    required String lblText,
    List<DataFindValues>? listValues,
  }) {
    return DrawerFind(
      widgetsHead: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ColorPalette.filled,
              side: const BorderSide(color: ColorPalette.lightItems10),
              foregroundColor: isLoading
                  ? ColorPalette.lightBackground
                  : ColorPalette.lightItems10,
            ),
            onPressed: () {},
            child: const Text(
              'Inventario almacén actual',
              style: Typo.labelDark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorPalette.lightBackground,
            side: const BorderSide(color: ColorPalette.lightItems10, width: 1),
            foregroundColor: isLoading
                ? ColorPalette.lightBackground
                : ColorPalette.lightItems10,
          ),
          onPressed: () {},
          child: const Text(
            'Todos los productos',
            style: Typo.labelLight,
          ),
        )),
      ],
      headerTable: subtitleList,
      lblText: lblText,
      listValues: listValues,
      isLoading: isLoading,
      onPressed: isLoading == true
          ? () {
              context.read<FinderForm>().setForm(TextfieldFormModel.empty());
              context.read<ProductFindCubit>().load('', warehouse);
            }
          : null,
      onSubmitted: isLoading == true
          ? (value) {
              context.read<ProductFindCubit>().load(value, warehouse);
            }
          : null,
    );
  }
}
