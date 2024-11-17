import 'package:flutter/material.dart';

import 'active_overlay_widget.dart';

void showActiveOverlay({
  required BuildContext context,
  required Widget content,
  required VoidCallback onClose,
  List<ButtonParams> buttons = const [],
  bool blackout = true,
  bool skippable = true,
}) {
  final overlayState = Overlay.of(context);

  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => ActiveOverlayWidget(
      content: content,
      onClose: () {
        overlayEntry.remove(); // Удаление overlay
        onClose();
      },
      buttons: buttons,
      blackout: blackout,
      skippable: skippable,
    ),
  );

  // Вставка оверлея в Overlay
  overlayState.insert(overlayEntry);
}
