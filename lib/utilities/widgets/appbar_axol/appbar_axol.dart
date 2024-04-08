import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'leading_appbar_axol.dart';
import '../loading_indicator/progress_indicator.dart';

class AppBarAxol {
  static PreferredSize appBar({
    required String title,
    LeadingAppBarAxol? leading,
    bool? isLoading,
  }) {
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
                leading: leading,
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
}
