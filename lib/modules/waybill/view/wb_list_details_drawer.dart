import 'package:axol_inventarios/modules/waybill/view/wb_list_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/format.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../cubit/list_details/wb_list_details_cubit.dart';
import '../cubit/list_details/wb_list_details_state.dart';
import '../model/waybill_list_model.dart';

/*class WbListDetailsDrawer extends StatelessWidget {
  final WaybillListModel waybill;
  const WbListDetailsDrawer({super.key, required this.waybill});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WbListDetailsCubit(),
      child: WbListDetailsViewBuild(
        waybill: waybill,
        user: user,
      ),
    );
  }
}

class WbListDetailsDrawerBuild extends StatelessWidget {
  const WbListDetailsDrawerBuild({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  

}*/
