import 'package:axol_inventarios/utilities/format.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../model/movement_model.dart';

class MovementDrawerDetails extends StatelessWidget {
  final MovementModel movement;
  const MovementDrawerDetails({super.key, required this.movement});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: const [],
      child: MovementDrawerDetailsBuild(movement: movement),
    );
  }
}

class MovementDrawerDetailsBuild extends StatelessWidget {
  final MovementModel movement;
  const MovementDrawerDetailsBuild({super.key, required this.movement});

  @override
  Widget build(BuildContext context) {
    return movementDrawerDetails(context, movement);
  }

  Widget movementDrawerDetails(BuildContext context, MovementModel movement) {
    return DrawerBox(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        header: const Text(
          'Detalles de movimiento al inventario',
          style: Typo.subtitleDark,
        ),
        actions: [
          SecondaryButtonDialog(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        children: [
          DrawerBox.rowKeyValue('${MovementModel.lblFolio}: ', movement.folio.toString()),
          DrawerBox.rowKeyValue(
              '${MovementModel.lblId}: ', movement.id),
          DrawerBox.rowKeyValue('${MovementModel.lblDocument}: ', movement.document),
          DrawerBox.rowKeyValue('${MovementModel.lblCode}: ', movement.code),
          DrawerBox.rowKeyValue('${MovementModel.lblDescription}: ', movement.description),
          DrawerBox.rowKeyValue('${MovementModel.lblConcept}: ', movement.concept.toString()),
          DrawerBox.rowKeyValue('${MovementModel.lblConceptType}: ', movement.conceptType.toString()),
          DrawerBox.rowKeyValue('${MovementModel.lblQuantity}: ', movement.quantity.toString()),
          DrawerBox.rowKeyValue('${MovementModel.lblStock}: ', movement.stock.toString()),
          DrawerBox.rowKeyValue('${MovementModel.lblTime}: ', FormatDate.dmy(movement.time)),
          DrawerBox.rowKeyValue('${MovementModel.lblUser}: ', movement.user),
          DrawerBox.rowKeyValue('${MovementModel.lblWarehouse}: ', movement.warehouseName),
        ]);
  }
}
