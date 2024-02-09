import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../cubit/product_details/product_details_cubit.dart';
import '../cubit/product_details/product_details_state.dart';
import '../model/product_model.dart';

class ProductDrawerDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProductDetailsCubit())],
      child: ProductDrawerDetailsBuild(
        product: product,
      ),
    );
  }
}

class ProductDrawerDetailsBuild extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerDetailsBuild({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is LoadingProductDetailsState) {
          return productDetailsCubit(context, true);
        } else if (state is LoadedProductDetailsState) {
          return productDetailsCubit(context, false);
        } else {
          return productDetailsCubit(context, true);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget productDetailsCubit(BuildContext context, bool isLoading) {
    return DrawerBox(
        header: const Text(
          'Detalles del producto',
          style: Typo.subtitleDark,
        ),
        actions: [
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          DrawerBox.rowKeyValue('Clave: ', product.code),
          DrawerBox.rowKeyValue('Descripción: ', product.description),
          DrawerBox.rowKeyValue('Empaque: ', product.packing ?? ''),
          DrawerBox.rowKeyValue('Tipo: ', product.type ?? ''),
          DrawerBox.rowKeyValue('Capacidad: ', product.capacity ?? ''),
          DrawerBox.rowKeyValue('Medida: ', product.measure ?? ''),
          DrawerBox.rowKeyValue('Calibre: ',
              product.gauge == null ? '' : product.gauge.toString()),
          DrawerBox.rowKeyValue('Presentación: ', product.pieces ?? ''),
          DrawerBox.rowKeyValue('Peso: ',
              product.weight == null ? '' : product.weight.toString()),
        ]);
  }
}
