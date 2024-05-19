import 'package:flutter/material.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/popup_menu_btn_axol.dart';
import '../model/modul_model.dart';

class ModuleBar extends StatelessWidget {
  final List<ModuleModel> moduleList;
  final int select;
  final bool menuVisible;
  final Function()? onPressedSetting;
  const ModuleBar(
      {super.key,
      required this.moduleList,
      required this.select,
      this.onPressedSetting,
      required this.menuVisible});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
                  icon: Icons.settings,
                  isHover: select == -1,
                  onPressed: onPressedSetting,
                  text: 'Configuración',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
                child: PopupMenuBtnAxol(
                  icon: Icons.person,
                  text: 'Cuenta',
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
        ),
        Visibility(
          visible: menuVisible,
          child: Container(
            width: 200,
            decoration: const BoxDecoration(
                color: ColorPalette.darkBackground,
                border:
                    Border(right: BorderSide(color: ColorPalette.darkItems20))),
            child: const Column(
              children: [Expanded(child: SizedBox())],
            ),
          ),
        ),
      ],
    );
  }

  Widget button(
      {bool? isHover, Function()? onPressed, IconData? icon, String? text}) {
    return SizedBox(
      height: 24,
      child: OutlinedButton(
          style: ButtonStyle(
            side: WidgetStateProperty.all(BorderSide.none),
            shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            //overlayColor: select == index
            overlayColor: isHover ?? false
                ? WidgetStateProperty.all(ColorPalette.darkItems10)
                : WidgetStateProperty.all(ColorPalette.darkItems20),
            //backgroundColor: select == index
            backgroundColor: isHover ?? false
                ? WidgetStateProperty.all(ColorPalette.darkItems10)
                : null,
            foregroundColor: WidgetStateProperty.resolveWith((Set states) {
              if (states.contains(WidgetState.hovered) || (isHover ?? false)) {
                return ColorPalette.lightText;
              } else {
                return ColorPalette.lightItems10;
              }
            }),
            textStyle: WidgetStateProperty.all(Typo.systemDark),
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
                width: 129,
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.start,
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Visibility(
                  replacement: const SizedBox(width: 10),
                    visible: isHover ?? false,
                    child: menuVisible
                        ? const Icon(
                            Icons.arrow_back_ios_new,
                            color: ColorPalette.lightText,
                            size: 10,
                          )
                        : const Icon(
                            Icons.arrow_forward_ios,
                            color: ColorPalette.lightText,
                            size: 10,
                          )),
              )
            ],
          )),
    );
  }
}
