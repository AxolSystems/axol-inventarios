import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/drawer_product/drawer_product_cubit.dart';
import '../../cubit/drawer_product/listen_drawer_cubit.dart';
import '../../cubit/product_tab/product_tab_cubit.dart';
import '../../model/product_model.dart';
import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../repository/product_repo.dart';
import '../controllers/drawer_product_controller.dart';
import 'drawer_details_product.dart';
import 'finder_products.dart';
import 'toolbar_products.dart';

/*class ListviewProducts extends StatelessWidget {
  final List<ProductModel> listData;
  final TextfieldModel finder;
  final int mode;
  static const String _type = 'type';
  static const String _weight = 'weight';
  static const String _packing = 'packing';

  const ListviewProducts(
      {super.key,
      required this.finder,
      required this.listData,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    Icon icon =
        const Icon(Icons.error_outline, color: ColorPalette.lightText);
    Function()? action;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              FinderProducts(
                currentFinder: finder,
                isLoading: false,
                mode: mode,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Clave',
                      style: Typo.bodyText5,
                    )),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Descripción',
                      style: Typo.bodyText5,
                    )),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Tipo',
                      style: Typo.bodyText5,
                    )),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Peso',
                      style: Typo.bodyText5,
                    )),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Empaque',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Visibility(
                    visible: mode > 0,
                    child: const Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(
                        '',
                        style: Typo.bodyText5,
                      )),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    final productRow = listData[index];

                    if (mode == 1) {
                      icon = const Icon(Icons.edit,
                          color: ColorPalette.lightText);
                      action = () {
                        showDialog(
                          context: context,
                          builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (_) => DrawerProductCubit()),
                                BlocProvider(
                                    create: (_) => ListenProductCubit(
                                        initialProduct:
                                            ProductModel.sortProduct(
                                                productRow))),
                              ],
                              child: DrawerProductController(
                                mode: mode,
                                initialProduct:
                                    ProductModel.sortProduct(productRow),
                              )),
                        ).then((value) {
                          if (value == true) {
                            context.read<ProductTabCubit>().load(
                                TextfieldModel(text: '', position: 0), 0);
                          }
                        });
                      };
                    } else if (mode == 2) {
                      icon = const Icon(Icons.highlight_remove,
                          color: ColorPalette.lightText);
                      action = () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content:
                                const Text('¿Desea elimnar este producto?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar')),
                              TextButton(
                                onPressed: () {
                                  ProductRepo().deleteProduct(productRow);
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              )
                            ],
                          ),
                        );
                      };
                    }
                    return Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45)),
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                DrawerDetailsProduct(product: productRow),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              //1) Clave
                              flex: 1,
                              child: Center(
                                child: Text(
                                  productRow.code,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 2) Descripción
                              flex: 1,
                              child: Center(
                                child: Text(
                                  productRow.description,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 3) Tipo
                              flex: 1,
                              child: Center(
                                child: Text(
                                  productRow.properties![_type],
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 4) Peso
                              flex: 1,
                              child: Center(
                                child: Text(
                                  '${productRow.properties![_weight]} KG',
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 5) Empaque
                              flex: 1,
                              child: Center(
                                child: Text(
                                  productRow.properties![_packing],
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            // 5) Eidt / delete
                            Visibility(
                              visible: mode > 0,
                              child: Expanded(
                                flex: 1,
                                child: Center(
                                  child: IconButton(
                                    onPressed: action,
                                    icon: icon,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ToolbarProducts(
          isLoading: false,
          mode: mode,
        ),
      ],
    );
  }
}*/
