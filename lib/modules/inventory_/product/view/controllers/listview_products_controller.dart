import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/product_tab/product_tab_cubit.dart';
import '../../cubit/product_tab/product_tab_state.dart';
import '../widgets/finder_products.dart';
import '../widgets/listview_products.dart';
import '../widgets/toolbar_products.dart';

/*class ListviewProductsController extends StatelessWidget {
  const ListviewProductsController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductTabCubit, ProductTabState>(
      bloc: context.read<ProductTabCubit>()..initLoad(),
      builder: (context, state) {
        if (state is LoadingProductTabState) {
          return Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  FinderProducts(
                    mode: state.mode,
                    isLoading: true,
                    currentFinder: state.finder,
                  ),
                  const LinearProgressIndicator(),
                  const Expanded(child: SizedBox())
                ],
              )),
              ToolbarProducts(
                isLoading: true,
                mode: state.mode,
              ),
            ],
          );
        } else if (state is LoadedProductTabState) {
          return ListviewProducts(
            mode: state.mode,
            finder: state.finder,
            listData: state.products,
          );
        } else if (state is ErrorProductTabState) {
          return Text(state.error, style: Typo.bodyText5,);
        } else {
          return Container();
        }
      },
    );
  }
}*/
