import 'package:axol_inventarios/modules/sale/sale_note/view/widgets/drawer_sale_note/textfield_salenote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/salenote_form_cubit.dart';

/*class DrawerSalenote extends StatelessWidget {
  final bool isLoading;

  const DrawerSalenote({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          color: Colors.black26,
        )),
        Drawer(
          width: 600,
          child: Column(
            children: [
              Visibility(visible: isLoading, child: LinearProgressIndicator()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Nueva nota'),
                      ),
                      Expanded(
                          child: ListView(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          TextfieldSalenote(
                            label: 'Cliente',
                            keyFormElement: 0,
                            isFocus: false,
                          ),
                          // ignore: prefer_const_constructors
                          TextfieldSalenote(
                            label: 'Vendor',
                            keyFormElement: 1,
                            isFocus: false,
                          ),
                          // ignore: prefer_const_constructors
                          TextfieldSalenote(
                            label: 'Warehouse',
                            keyFormElement: 2,
                            isFocus: false,
                          ),
                          const Divider(),
                          const Center(
                            child: Text('Cliente'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .id ==
                                  -1
                              ? 'Id: '
                              : 'Id: ${context.read<SalenoteFormCubit>().state.customerModel.id}'),
                          Text(
                              'Nombre: ${context.read<SalenoteFormCubit>().state.customerModel.name}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .rfc ==
                                  null
                              ? 'RFC: '
                              : 'RFC: ${context.read<SalenoteFormCubit>().state.customerModel.rfc}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .street ==
                                  null
                              ? 'Calle: '
                              : 'Calle: ${context.read<SalenoteFormCubit>().state.customerModel.street}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .outNumber ==
                                  null
                              ? 'Número externo: '
                              : 'Número externo: ${context.read<SalenoteFormCubit>().state.customerModel.outNumber}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .intNumber ==
                                  null
                              ? 'Número interno: '
                              : 'Número interno: ${context.read<SalenoteFormCubit>().state.customerModel.intNumber}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .hood ==
                                  null
                              ? 'Colonia: '
                              : 'Colonia: ${context.read<SalenoteFormCubit>().state.customerModel.hood}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .postalCode ==
                                  null
                              ? 'Código postal: '
                              : 'Código postal: ${context.read<SalenoteFormCubit>().state.customerModel.postalCode}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .town ==
                                  null
                              ? 'Ciudad: '
                              : 'Ciudad: ${context.read<SalenoteFormCubit>().state.customerModel.town}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .country ==
                                  null
                              ? 'Estado: '
                              : 'Estado: ${context.read<SalenoteFormCubit>().state.customerModel.country}'),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .customerModel
                                      .phoneNumber ==
                                  null
                              ? 'Número de telefono: '
                              : 'Número de telefono: ${context.read<SalenoteFormCubit>().state.customerModel.phoneNumber}'),
                          const Divider(),
                          const Center(
                            child: Text('Vendedor'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .vendorModel
                                      .id ==
                                  -1
                              ? 'Id: '
                              : 'Id: ${context.read<SalenoteFormCubit>().state.vendorModel.id}'),
                          Text(
                              'Nombre: ${context.read<SalenoteFormCubit>().state.vendorModel.name}'),
                          const Divider(),
                          const Center(
                            child: Text('Almacén'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(context
                                      .read<SalenoteFormCubit>()
                                      .state
                                      .warehouseModel
                                      .id ==
                                  -1
                              ? 'Id: '
                              : 'Id: ${context.read<SalenoteFormCubit>().state.warehouseModel.id}'),
                          Text(
                              'Nombre: ${context.read<SalenoteFormCubit>().state.warehouseModel.name}'),
                          Text(
                              'Encargado: ${context.read<SalenoteFormCubit>().state.warehouseModel.retailManager}'),
                          const Divider(),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}*/
