import 'package:axol_inventarios/utilities/widgets/alert_dialog_axol.dart';
import 'package:axol_inventarios/utilities/widgets/textfield_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../cubit/product_edit/product_edit_cubit.dart';
import '../cubit/product_edit/product_edit_form.dart';
import '../cubit/product_edit/product_edit_state.dart';
import '../model/product_edit_form_model.dart';
import '../model/product_model.dart';

class ProductDrawerEdit extends StatelessWidget {
  final ProductModel product;
  const ProductDrawerEdit({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductEditCubit()),
        BlocProvider(create: (_) => ProductEditForm()),
      ],
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
    ProductEditFormModel form = context.read<ProductEditForm>().state;
    return BlocConsumer<ProductEditCubit, ProductEditState>(
      bloc: context.read<ProductEditCubit>()..initLoad(product, form),
      builder: (context, state) {
        if (state is LoadingProductEditState) {
          return productEditCubit(context, true, form);
        } else if (state is LoadedProductEditState) {
          return productEditCubit(context, false, form);
        } else {
          return productEditCubit(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorProductEditState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
        if (state is SavedProductEditState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget productEditCubit(
      BuildContext context, bool isLoading, ProductEditFormModel form) {
    return DrawerBox(
      padding: const EdgeInsets.symmetric(horizontal: 8),
        width: 0.45,
        header: const Text(
          'Editar producto',
          style: Typo.subtitleDark,
        ),
        actions: [
          PrimaryButtonDialog(
            text: 'Guardar',
            onPressed: () async {
              context.read<ProductEditCubit>().save(form, product.code, product.price);
            },
          ),
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        child: isLoading
            ? const Expanded(
                child: Column(
                children: [
                  LinearProgressIndicatorAxol(),
                  Expanded(child: SizedBox())
                ],
              ))
            : null,
        children: [
          DrawerBox.rowKeyValue('Clave: ', product.code),
          TextFieldInputForm(
            controller: form.tfDescription.controller,
            label: ProductModel.lblDescription,
            isFocus: form.focusIndex == 0,
            onSubmitted: (value) {
              form.focusIndex = 1;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfPacking.controller,
            label: ProductModel.lblPacking,
            isFocus: form.focusIndex == 1,
            onSubmitted: (value) {
              form.focusIndex = 2;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfType.controller,
            label: ProductModel.lblType,
            isFocus: form.focusIndex == 2,
            onSubmitted: (value) {
              form.focusIndex = 3;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfCapacity.controller,
            label: ProductModel.lblCapacity,
            isFocus: form.focusIndex == 3,
            onSubmitted: (value) {
              form.focusIndex = 4;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfMasure.controller,
            label: ProductModel.lblMeasure,
            isFocus: form.focusIndex == 4,
            onSubmitted: (value) {
              form.focusIndex = 5;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfGauge.controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            label: ProductModel.lblGauge,
            isFocus: form.focusIndex == 5,
            onSubmitted: (value) {
              form.focusIndex = 6;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfPices.controller,
            label: ProductModel.lblPieces,
            isFocus: form.focusIndex == 6,
            onSubmitted: (value) {
              form.focusIndex = 7;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfWeight.controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            label: ProductModel.lblWeight,
            isFocus: form.focusIndex == 7,
            onSubmitted: (value) {
              form.focusIndex = 8;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfPrice.controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            label: ProductModel.lblPrice,
            isFocus: form.focusIndex == 8,
            onSubmitted: (value) {
              form.focusIndex = 9;
              context.read<ProductEditCubit>().load();
            },
          ),
          TextFieldInputForm(
            controller: form.tfUnitSale.controller,
            label: ProductModel.lblUnit,
            isFocus: form.focusIndex == 9,
            onSubmitted: (value) {
              form.focusIndex = 10;
              context.read<ProductEditCubit>().load();
            },
          ),
          DropdownButton(
            value: form.class_,
            items: const [
              DropdownMenuItem(
                value: -1,
                child: Text('Sin clasificación'),
              ),
              DropdownMenuItem(
                value: 0,
                child: Text('0 - Bolsa negra'),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text('1 - Bolsa negra en caja'),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('2 - Bolsa negra contada'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('3 - Stretch film'),
              ),
              DropdownMenuItem(
                value: 4,
                child: Text('4 - Poliducto'),
              ),
              DropdownMenuItem(
                value: 5,
                child: Text('5 - Rollo negro extrusion'),
              ),
              DropdownMenuItem(
                value: 6,
                child: Text('6 - Resina baja densidad'),
              ),
              DropdownMenuItem(
                value: 7,
                child: Text('7 - Bolsa camiseta'),
              ),
              DropdownMenuItem(
                value: 8,
                child: Text('8 - Resina alta densidad'),
              ),
            ],
            onChanged: (value) {
              form.class_ = value ?? -1;
              context.read<ProductEditCubit>().load();
            },
          )
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
