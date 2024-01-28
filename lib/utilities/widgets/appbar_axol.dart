import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../../global_widgets/appbar/iconbutton_return.dart';
import 'loading_indicator/progress_indicator.dart';

class AppBarAxol extends StatelessWidget {
  final String title;
  final IconButtonReturn? iconButton;
  final bool? isLoading;

  const AppBarAxol({
    super.key,
    required this.title,
    this.iconButton,
    this.isLoading,
  });

  PreferredSize appBarAxol() {
    final isLoading_ = isLoading ?? false;
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 1,
            color: ColorPalette.darkItems,
          ))),
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 45,
                backgroundColor: ColorPalette.darkBackground,
                automaticallyImplyLeading: false,
                leading: iconButton,
                title: Text(
                  title,
                  style: Typo.title1,
                ),
                centerTitle: true,
                elevation: 0,
              ),
              Visibility(
                visible: isLoading_,
                replacement: const SizedBox(height: 4),
                child: const LinearProgressIndicatorAxol(),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return appBarAxol();
  }
}
