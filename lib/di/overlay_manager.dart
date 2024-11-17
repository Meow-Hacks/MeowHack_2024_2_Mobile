import 'package:flutter/material.dart';
import 'package:meow_hack_app/app/uikit/widgets/active_overlay/active_overlay_widget.dart';

class OverlayManager extends ChangeNotifier {
  OverlayEntry? _overlayEntry;

  void showOverlay(BuildContext context, Widget content) {
    if (_overlayEntry != null) {
      return; // Не показывать новый overlay, если он уже существует
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => ActiveOverlayWidget(
        content: content,
        onClose: hideOverlay,
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    notifyListeners();
  }

  bool get isOverlayVisible => _overlayEntry != null;
}
