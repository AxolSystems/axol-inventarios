import 'package:axol_inventarios/modules/user/view/views/login_view.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';

import '../../../modules/user/repository/user_repo.dart';
import '../../theme/theme.dart';
import '../dialog.dart';

class NavRailAxol extends StatelessWidget {
  final Widget navRailMain;
  const NavRailAxol({super.key, required this.navRailMain});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      decoration: const BoxDecoration(color: ColorPalette.darkBackground),
      child: Column(
        children: [
          Expanded(child: navRailMain),
          const Divider(
            color: ColorPalette.darkItems20,
            height: 0,
          ),
          Material(
            color: Colors.transparent,
            type: MaterialType.circle,
            clipBehavior: Clip.antiAlias,
            borderOnForeground: true,
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialogAxol(
                          text: '¿Desea cerrar sesión?',
                          actions: [
                            PrimaryButtonDialog(
                              text: 'Aceptar',
                              onPressed: () {
                                LocalUser().setLocalUser('', '', -1);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginView()));
                              },
                            ),
                            SecondaryButtonDialog(
                              text: 'Cancelar',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.logout,
                color: ColorPalette.lightItems10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
