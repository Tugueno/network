import 'dart:js_interop';

@JS('setThemeColor')
external void _setThemeColor(JSString color);

void setThemeColor(String color) {
  try {
    _setThemeColor(color.toJS);
  } catch (_) {
    // The JS bridge is defined in web/index.html. Ignore calls during tests or
    // custom hosts that have not loaded that bootstrap script.
  }
}
