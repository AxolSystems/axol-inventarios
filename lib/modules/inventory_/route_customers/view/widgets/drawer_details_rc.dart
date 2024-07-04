import 'package:axol_inventarios/modules/inventory_/route_customers/model/routcustomer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/rc_details_cubit/rc_details_cubit.dart';

class DrawerDetailsRc extends StatelessWidget {
  final bool isLoading;
  final RoutcustomerModel rc;
  final bool isValid;

  const DrawerDetailsRc(
      {super.key,
      required this.isLoading,
      required this.rc,
      required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          color: Colors.black26,
        )),
        Drawer(
          width: 500,
          child: Column(
            children: [
              Visibility(
                  visible: isLoading, child: const LinearProgressIndicator()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Nuevo cliente de rtua'),
                      ),
                      Expanded(
                          child: ListView(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Id:'),
                              Text(rc.id.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nombre:'),
                              Text(rc.name),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ubicación:'),
                              Text(rc.location)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Dirección:'),
                              Text(rc.address[RoutcustomerModel.pAddress]
                                  .toString())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Colonia:'),
                              Text(rc.address[RoutcustomerModel.pHood])
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Municipio:'),
                              Text(rc.address[RoutcustomerModel.pTown])
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Estado:'),
                              Text(rc.address[RoutcustomerModel.pCountry])
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Vendedor:'),
                              Text(rc.address[RoutcustomerModel.pVendor].toString())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Validación:'),
                              Switch(
                                value: isValid,
                                onChanged: (value) {
                                  context.read<RcDetailsCubit>().change(value);
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Usuario que valido:'),
                              Text(rc.validation[RoutcustomerModel.pAdminUser])
                            ],
                          ),
                        ],
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              if (isLoading == false) {
                                await context.read<RcDetailsCubit>().updateRcValidation(
                                    rc,
                                    isValid,
                                    rc.validation[RoutcustomerModel.pAdminUser],
                                  );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
                      )
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
}
