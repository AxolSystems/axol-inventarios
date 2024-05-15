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
      decoration: const BoxDecoration(
        color: ColorPalette.darkBackground,
        border: Border(right: BorderSide(color: ColorPalette.darkItems20)),
      ),
      height: double.infinity,
      width: 200,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: moduleList.length,
              itemBuilder: (context, index) {
                final module = moduleList[index];
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(8)),
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
                        textStyle: MaterialStateProperty.all(Typo.labelDark),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: module.onPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            module.icon,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 147,
                            child: Text(
                              module.text,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ),
          const Divider(
            color: ColorPalette.darkItems20,
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                  overlayColor:
                      MaterialStateProperty.all(ColorPalette.darkItems20),
                  /*backgroundColor: select == index
                            ? MaterialStateProperty.all(
                                ColorPalette.darkItems10)
                            : null,*/
                  foregroundColor:
                      MaterialStateProperty.resolveWith((Set states) {
                    if (states.contains(MaterialState.hovered)) {
                      return ColorPalette.lightText;
                    } else {
                      return ColorPalette.lightItems10;
                    }
                  }),
                  textStyle: MaterialStateProperty.all(Typo.labelDark),
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  final heightScreen = MediaQuery.of(context).size.height;
                  /*showMenu(
                    popUpAnimationStyle:
                        AnimationStyle(duration: const Duration()),
                    color: ColorPalette.darkBackground,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    context: context,
                    position:
                        RelativeRect.fromLTRB(0, heightScreen - 170, 0, 0),
                    items: <PopupMenuEntry<int>>[
                      const PopupMenuItem(
                        value: 0,
                        enabled: false,
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            "Usuario",
                            style: Typo.labelLight,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 1,
                        child: Text("Cerrar sesión", style: Typo.labelLight),
                      ),
                    ],
                  );*/
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 147,
                      child: Text(
                        'Usuario',
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
