import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:axol_inventarios/utilities/widgets/textfield_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../cubit/product_edit/product_edit_cubit.dart';
import '../cubit/product_edit/product_edit_state.dart';
import '../model/product_model.dart';

class ProductDrawerEdit extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerEdit({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProductEditCubit())],
      child: ProductDrawerEditBuild(
        product: product,
      ),
    );
  }
}

class ProductDrawerEditBuild extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerEditBuild({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductEditCubit, ProductEditState>(
      builder: (context, state) {
        if (state is LoadingProductEditState) {
          return productEditCubit(context, true);
        } else if (state is LoadedProductEditState) {
          return productEditCubit(context, false);
        } else {
          return productEditCubit(context, true);
        }
      },
      listener: (context, state) {
        if (state is ErrorProductEditState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
    );
  }

  Widget productEditCubit(BuildContext context, bool isLoading) {
    return DrawerBox(
        header: const Text(
          'Editar producto',
          style: Typo.subtitleDark,
        ),
        actions: [
          const PrimaryButtonDialog(
            text: 'Guardar',
          ),
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          DrawerBox.rowKeyValue('Clave: ', product.code),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Descripción',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Empaque',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Tipo',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Capacidad',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Medida',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Calibre',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Presentación',
          ),
          TextFieldInputForm(
            controller: TextEditingController(),
            label: 'Descripción',
          ),
          //DrawerBox.rowKeyValue('Descripción: ', product.description),
          //DrawerBox.rowKeyValue('Empaque: ', product.packing ?? ''),
          //DrawerBox.rowKeyValue('Tipo: ', product.type ?? ''),
          //DrawerBox.rowKeyValue('Capacidad: ', product.capacity ?? ''),
          //DrawerBox.rowKeyValue('Medida: ', product.measure ?? ''),
          //DrawerBox.rowKeyValue('Calibre: ',
          //    product.gauge == null ? '' : product.gauge.toString()),
          //DrawerBox.rowKeyValue('Presentación: ', product.pieces ?? ''),
          //DrawerBox.rowKeyValue('Peso: ',
          //   product.weight == null ? '' : product.weight.toString()),
        ]);
  }
}
