import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utilities/theme/theme.dart';
import '../../../cubit/inventory_load/inventory_load_cubit.dart';
import '../../../cubit/inventory_load/inventory_load_state.dart';
import '../../../model/inventory_move/concept_move_model.dart';
import '../../../../../../utilities/widgets/drawer_box.dart';
import '../textfield_finder_inventoryrow.dart';
import 'listview_dialog_finder.dart';

class DrawerFindProduct extends StatelessWidget {
  final String inventoryName;
  final ConceptMoveModel concept;

  const DrawerFindProduct(
      {super.key, required this.inventoryName, required this.concept});

  @override
  Widget build(BuildContext context) {
    InventoryLoadCubit? cubitLoadInventory;
    if (concept.type == 0) {
      cubitLoadInventory = context.read<InventoryLoadCubit>()..loadProducts();
    } else {
      cubitLoadInventory =
        context.read<InventoryLoadCubit>()..loadInventory(inventoryName, '');
    }
    return DrawerBox(
      width: 0.5,
      header: Column(
        children: [
          const Text(
            'Busqueda de productos',
            style: Typo.titleDark,
          ),
          Material(
            child: Row(
              children: [
                Expanded(
                    child: TextfieldFinderInventroyrow(
                  inventoryName: inventoryName,
                  isWithStock: concept.type == 0 ? false : true,
                )),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    'Clave',
                    style: Typo.subtitleDark,
                  ))),
              const Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Descripción',
                      style: Typo.subtitleDark,
                    ),
                  )),
              concept.type == 1
                  ? const Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(
                        'Stock',
                        style: Typo.subtitleDark,
                      )),
                    )
                  : const Text(''),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ColorPalette.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Regresar',
              style: Typo.bodyLight,
            ),
          ),
        )
      ],
      child: BlocBuilder<InventoryLoadCubit, InventoryLoadState>(
        bloc: cubitLoadInventory,
        builder: (context, state) {
          if (state is LoadingState) {
            return Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const LinearProgressIndicator(), Container()],
            ));
          } else if (state is LoadedInventory) {
            return ListviewFindProduct(
              inventoryList: state.inventoryList,
              isWithStock: true,
            );
          } else if (state is LoadedProducts) {
            return ListviewFindProduct(
              productList: state.productList,
              isWithStock: false,
            );
          } else if (state is ErrorState) {
            return Text(
              state.error,
              style: const TextStyle(color: Colors.red),
            );
          } else {
            return const Text(
              'Error de estado.',
              style: TextStyle(color: Colors.red),
            );
          }
        },
      ),
    );
  }
}
