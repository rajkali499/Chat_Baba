import 'package:chat_baba/ui/components/custom_loader.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  static final LoadingOverlay _singleton = LoadingOverlay._internal();

  factory LoadingOverlay() {
    return _singleton;
  }

  LoadingOverlay._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry != null) {
      // Overlay is already showing
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => const CustomCircularProgressIndicator(),
    );

    final overlay = Overlay.of(context);
    overlay.insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
