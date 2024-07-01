import 'package:flutter/material.dart';

/// Widget contenedor con scroll vertical y horizontal. 
/// El hijo debe tener medidas definidas para no causar conflicto.
class ScrollViewAxol extends StatelessWidget {
  final Widget? child;
  const ScrollViewAxol({super.key, this.child});

  /// Crea el widget de vista scrolls.
  @override
  Widget build(BuildContext context) {
    ScrollController scrollCtrlVertical = ScrollController();
    ScrollController scrollCtrlHorizontal = ScrollController();
    return RawScrollbar(
      controller: scrollCtrlVertical,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      radius: const Radius.circular(8),
      thickness: 12,
      scrollbarOrientation: ScrollbarOrientation.right,
      child: RawScrollbar(
        padding: const EdgeInsets.only(right: 12),
        controller: scrollCtrlHorizontal,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        radius: const Radius.circular(8),
        notificationPredicate: (ScrollNotification notify) => notify.depth == 1,
        thickness: 12,
        child: SingleChildScrollView(
          controller: scrollCtrlVertical,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            primary: false,
            controller: scrollCtrlHorizontal,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
