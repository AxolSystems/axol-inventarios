import 'package:axol_inventarios/modules/user/model/user_model.dart';
import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../cubit/product_details/product_details_cubit.dart';
import '../cubit/product_details/product_details_state.dart';
import '../model/product_model.dart';
import 'product_drawer_edit.dart';

class ProductDrawerDetails extends StatelessWidget {
  final ProductModel product;
  final UserModel user;
  final bool? actions;
  const ProductDrawerDetails(
      {super.key, required this.product, this.actions, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProductDetailsCubit())],
      child: ProductDrawerDetailsBuild(
        product: product,
        actions: actions ?? false,
        user: user,
      ),
    );
  }
}

class ProductDrawerDetailsBuild extends StatelessWidget {
  final ProductModel product;
  final bool actions;
  final UserModel user;
  const ProductDrawerDetailsBuild(
      {super.key,
      required this.product,
      required this.actions,
      required this.user});

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
    final widthScreen = MediaQuery.of(context).size.width;
    final bool editable;

    if (user.rol == UserModel.rolAdmin) {
      editable = true;
    } else {
      editable = false;
    }

    return DrawerBox(
        width: widthScreen > 760
            ? 0.5
            : widthScreen > 450
                ? 0.8
                : 0.95,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        header: const Text(
          'Detalles del producto',
          style: Typo.subtitleDark,
        ),
        actions: [
          Visibility(
            visible: actions && editable,
            child: SecondaryButtonDialog(
              text: 'Editar',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ProductDrawerEdit(
                    product: product,
                  ),
                );
              },
            ),
          ),
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
          DrawerBox.rowKeyValue('Precio: ', '\$ ${FormatNumber.format2dec(product.price)}'),
          DrawerBox.rowKeyValue('Unidad de venta: ', product.unitSale),
        ]);
  }
}
