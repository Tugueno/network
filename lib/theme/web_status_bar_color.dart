import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'web_status_bar_color_stub.dart'
    if (dart.library.html) 'web_status_bar_color_web.dart'
    as platform;

class WebStatusBarColor {
  WebStatusBarColor._();

  static String? _lastColor;

  static void setColor(Color color) {
    if (!kIsWeb) return;

    final cssColor = _toCssColor(color);
    if (_lastColor == cssColor) return;

    _lastColor = cssColor;
    platform.setThemeColor(cssColor);
  }

  static String _toCssColor(Color color) {
    final argb = color.toARGB32();
    final red = ((argb >> 16) & 0xff).toRadixString(16).padLeft(2, '0');
    final green = ((argb >> 8) & 0xff).toRadixString(16).padLeft(2, '0');
    final blue = (argb & 0xff).toRadixString(16).padLeft(2, '0');

    return '#$red$green$blue'.toUpperCase();
  }
}
