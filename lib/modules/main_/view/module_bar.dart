import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

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
          const PopoverButton(),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: button(
              icon: Icons.settings,
              onPressed: () {
                
              },
              text: 'Configuración',
            ),
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
              if (states.contains(WidgetState.hovered) ||
                  (isHover ?? false)) {
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

class PopoverButton extends StatelessWidget {
  final bool? isHover;
  final Function()? onPressed;
  final IconData? icon;
  final String? text;
  const PopoverButton(
      {super.key, this.isHover, this.onPressed, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: OutlinedButton(
          style: ButtonStyle(
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
              if (states.contains(WidgetState.hovered) ||
                  (isHover ?? false)) {
                return ColorPalette.lightText;
              } else {
                return ColorPalette.lightItems10;
              }
            }),
            textStyle: WidgetStateProperty.all(Typo.systemDark),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            showPopover(
              context: context,
              bodyBuilder: (context) => const Text('Prueba'),
              direction: PopoverDirection.right,
              backgroundColor: ColorPalette.darkBackground,
              barrierColor: Colors.transparent,
              width: 200,
              height: 400,
              arrowHeight: 10,
              arrowWidth: 10,
            );
          },
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
