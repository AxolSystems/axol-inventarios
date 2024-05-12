import 'package:axol_inventarios/modules/modules_/model/modul_model.dart';
import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';
import 'module_bar.dart';

class ExperimentalView extends StatelessWidget {
  const ExperimentalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ModuleBar(
            moduleList: [
              ModuleModel(
                text: 'Modulo de prueba',
                id: '0',
                icon: Icons.home,
                position: 0,
                menu: [],
                permissions: {},
              )
            ],
          ),
          Expanded(
              child: Container(
            color: ColorPalette.darkBackground,
          )),
        ],
      ),
    );
  }
}
