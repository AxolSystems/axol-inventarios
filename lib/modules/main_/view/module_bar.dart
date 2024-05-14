import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';
import '../model/modul_model.dart';

class ModuleBar extends StatelessWidget {
  final List<ModuleModel> moduleList;
  final int select;
  const ModuleBar({super.key, required this.moduleList, required this.select});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.darkBackground,
      height: double.infinity,
      width: 80,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: moduleList.length,
              itemBuilder: (context, index) {
                final module = moduleList[index];
                return SizedBox(
                  child: OutlinedButton(
                      style: ButtonStyle(
                        overlayColor: select == index
                            ? MaterialStateProperty.all(
                                ColorPalette.darkItems10)
                            : MaterialStateProperty.all(
                                ColorPalette.darkItems20),
                        backgroundColor: select == index
                            ? MaterialStateProperty.all(
                                ColorPalette.darkItems10)
                            : null,
                        foregroundColor:
                            MaterialStateProperty.resolveWith((Set states) {
                          if (states.contains(MaterialState.hovered) ||
                              select == index) {
                            return ColorPalette.lightText;
                          } else {
                            return ColorPalette.lightItems10;
                          }
                        }),
                        textStyle: MaterialStateProperty.all(Typo.labelLight),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: module.onPressed,
                      child: Column(
                        children: [
                          Icon(
                            module.icon,
                            //color: ColorPalette.lightItems10,
                          ),
                          Text(
                            module.text,
                            textAlign: TextAlign.center,
                            //style: Typo.labelLight,
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
