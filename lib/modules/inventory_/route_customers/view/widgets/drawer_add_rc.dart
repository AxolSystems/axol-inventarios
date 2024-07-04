// ignore_for_file: prefer_const_constructors

import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_drawer_cubit/rc_drawer_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/model/rc_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/vendor_select_cubit/vendor_select_cubit.dart';
import '../controller/select_vendor_controller.dart';
import 'textfield_rc.dart';

class DrawerAddRc extends StatelessWidget {
  final bool isLoading;

  const DrawerAddRc({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool isValid = context.read<RcFormCubit>().state.status;
    RcFormModel rcForm;
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
              Visibility(visible: isLoading, child: LinearProgressIndicator()),
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
                          TextfieldRc(
                            label: 'Id:',
                            keyFormElement: 0,
                            isFocus: false,
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*$')),
                            ],
                          ),
                          TextfieldRc(
                            label: 'Nombre:',
                            keyFormElement: 1,
                            isFocus: false,
                          ),
                          TextfieldRc(
                            label: 'Ubicación:',
                            keyFormElement: 2,
                            isFocus: false,
                          ),
                          TextfieldRc(
                            label: 'Dirección:',
                            keyFormElement: 3,
                            isFocus: false,
                          ),
                          TextfieldRc(
                            label: 'Colonia:',
                            keyFormElement: 4,
                            isFocus: false,
                          ),
                          TextfieldRc(
                            label: 'Municipio:',
                            keyFormElement: 5,
                            isFocus: false,
                          ),
                          TextfieldRc(
                            label: 'Estado:',
                            keyFormElement: 6,
                            isFocus: false,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextfieldRc(
                                label: 'Vendedor:',
                                keyFormElement: 7,
                                isFocus: false,
                                width: 260,
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          MultiBlocProvider(providers: [
                                        BlocProvider(
                                            create: (_) => VendorSelectCubit()),
                                      ], child: const SelectVendorController()),
                                    ).then((value) {
                                      context.read<RcFormCubit>().changeForm(
                                          value.toString(),
                                          value.toString().length,
                                          7);
                                      context.read<RcDrawerCubit>().change();
                                    });
                                  },
                                  icon: Icon(Icons.search))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Validado:'),
                              Switch(
                                  value: isValid,
                                  onChanged: (value) {
                                    context
                                        .read<RcFormCubit>()
                                        .changeStatus(!isValid);
                                    context.read<RcDrawerCubit>().change();
                                  })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Usuario:'),
                              Text(context.read<RcFormCubit>().state.user)
                            ],
                          )
                        ],
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              if (isLoading == false) {
                                context.read<RcFormCubit>().allValidate();
                                rcForm = context.read<RcFormCubit>().state;
                                if (rcForm.id.validation.isValid &&
                                    rcForm.name.validation.isValid &&
                                    rcForm.location.validation.isValid &&
                                    rcForm.address.validation.isValid &&
                                    rcForm.hood.validation.isValid &&
                                    rcForm.town.validation.isValid &&
                                    rcForm.country.validation.isValid &&
                                    rcForm.vendor.validation.isValid) {
                                  await context
                                      .read<RcDrawerCubit>()
                                      .insertRc(rcForm);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, true);
                                } else {
                                  context.read<RcDrawerCubit>().change();
                                }
                              }
                            },
                            child: Text('Guardar'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Cancelar'),
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
