import 'package:axol_inventarios/models/textfield_model.dart';
import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/toolbar.dart';
import '../../../../../models/elemnets_bar_model.dart';
import '../../cubit/drawer_product/drawer_product_cubit.dart';
import '../../cubit/drawer_product/listen_drawer_cubit.dart';
import '../../cubit/product_tab/product_tab_cubit.dart';
import '../controllers/drawer_product_controller.dart';

/*class ToolbarProducts extends StatelessWidget {
  final bool isLoading;
  final int mode;

  const ToolbarProducts(
      {super.key, required this.isLoading, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Toolbar(
      listData: [
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.add),
          action: () {
            if (isLoading == false && mode == 0) {
              showDialog(
                context: context,
                builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => DrawerProductCubit()),
                      BlocProvider(
                          create: (_) => ListenProductCubit(
                              initialProduct: ProductModel.empty())),
                    ],
                    child: DrawerProductController(
                      mode: mode,
                      initialProduct: ProductModel.empty(),
                    )),
              ).then((value) {
                if (value == true) {
                  context
                      .read<ProductTabCubit>()
                      .load(TextfieldModel(text: '', position: 0), 0);
                }
              });
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.edit_square),
          secondaryColor: mode == 1 ? Colors.white : null,
          action: () {
            if (isLoading == false) {
              if (mode == 1) {
                context
                    .read<ProductTabCubit>()
                    .load(TextfieldModel(text: '', position: 0), 0);
              } else {
                context
                    .read<ProductTabCubit>()
                    .load(TextfieldModel(text: '', position: 0), 1);
              }
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.delete),
          secondaryColor: mode == 2 ? Colors.white : null,
          action: () {
            if (isLoading == false) {
              if (mode == 2) {
                context
                    .read<ProductTabCubit>()
                    .load(TextfieldModel(text: '', position: 0), 0);
              } else {
                context
                    .read<ProductTabCubit>()
                    .load(TextfieldModel(text: '', position: 0), 2);
              }
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.restart_alt),
          action: () {
            if (isLoading == false) {
              context.read<ProductTabCubit>().initLoad();
            }
          },
        ),
      ],
    );
  }
}*/
