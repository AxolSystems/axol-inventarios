import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_drawer_cubit/rc_drawer_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_form_cubit.dart';
import 'package:axol_inventarios/modules/inventory_/route_customers/view/controller/drawer_add_rc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_widgets/toolbar.dart';
import '../../../../../models/elemnets_bar_model.dart';
import '../../../../../models/textfield_model.dart';
import '../../cubit/routcustomer cubit/routcustomer_cubit.dart';

class ToolbarRc extends StatelessWidget {
  final bool isLoading;

  const ToolbarRc({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Toolbar(
      listData: [
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.add),
          action: () {
            if (isLoading == false) {
              showDialog(
                context: context,
                builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (_) => RcDrawerCubit()),
                  BlocProvider(create: (_) => RcFormCubit()),
                ], child: const DrawerAddRcController()),
              ).then((value) {
                if (value == true) {
                  context
                      .read<RoutcustomerCubit>()
                      .load(TextfieldModel.empty());
                }
              });
            }
          },
        ),
        ElementsBarModel(
          text: null,
          icon: const Icon(Icons.restart_alt),
          action: () {
            if (isLoading == false) {
              context.read<RoutcustomerCubit>().load(TextfieldModel.empty());
            }
          },
        ),
      ],
    );
  }
}
