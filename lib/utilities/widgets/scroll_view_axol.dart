import 'package:flutter/material.dart';

/// Widget contenedor con scroll vertical y horizontal.
/// El hijo debe tener medidas definidas para no causar conflicto.
class ScrollViewAxol extends StatelessWidget {
  final Widget? child;
  final ScrollController? scrollCtrlVertical;
  final ScrollController? scrollCtrlHorizontal;
  const ScrollViewAxol(
      {super.key,
      this.child,
      this.scrollCtrlHorizontal,
      this.scrollCtrlVertical});

  /// Crea el widget de vista scrolls.
  @override
  Widget build(BuildContext context) {
    ScrollController scrollCtrlVertical_ =
        scrollCtrlVertical ?? ScrollController();
    ScrollController scrollCtrlHorizontal_ =
        scrollCtrlHorizontal ?? ScrollController();
    return RawScrollbar(
      controller: scrollCtrlVertical_,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      radius: const Radius.circular(8),
      thickness: 12,
      scrollbarOrientation: ScrollbarOrientation.right,
      child: RawScrollbar(
        padding: const EdgeInsets.only(right: 12),
        controller: scrollCtrlHorizontal_,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        radius: const Radius.circular(8),
        notificationPredicate: (ScrollNotification notify) => notify.depth == 1,
        thickness: 12,
        child: SingleChildScrollView(
          controller: scrollCtrlVertical_,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            primary: false,
            controller: scrollCtrlHorizontal_,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
