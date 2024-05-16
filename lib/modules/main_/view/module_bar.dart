import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/popup_menu_btn_axol.dart';
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
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: button(
                      icon: module.icon,
                      isHover: select == index,
                      text: module.text,
                      onPressed: module.onPressed),
                );
              },
            ),
          ),
          const Divider(
            color: ColorPalette.darkItems20,
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: button(
                icon: Icons.settings, onPressed: () {}, text: 'Configuración'),
          ),
          const Padding(
            padding: EdgeInsets.all(4),
            child: PopupMenuBtnAxol(
              icon: Icons.person,
              text: 'Usuario',
              entryList: <PopupMenuEntry<int>>[
                PopupMenuItem(
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
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 1,
                  child: Text("Cerrar sesión", style: Typo.labelLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button(
      {bool? isHover, Function()? onPressed, IconData? icon, String? text}) {
    return SizedBox(
      height: 24,
      child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            //overlayColor: select == index
            overlayColor: isHover ?? false
                ? MaterialStateProperty.all(ColorPalette.darkItems10)
                : MaterialStateProperty.all(ColorPalette.darkItems20),
            //backgroundColor: select == index
            backgroundColor: isHover ?? false
                ? MaterialStateProperty.all(ColorPalette.darkItems10)
                : null,
            foregroundColor: MaterialStateProperty.resolveWith((Set states) {
              if (states.contains(MaterialState.hovered) ||
                  (isHover ?? false)) {
                return ColorPalette.lightText;
              } else {
                return ColorPalette.lightItems10;
              }
            }),
            textStyle: MaterialStateProperty.all(Typo.systemDark),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 147,
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.start,
                ),
              )
            ],
          )),
    );
  }
}
