import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import '../../location/picked_location.dart';
import '../../location/web_picked_location.dart';
import '../../options/android_options.dart';
import '../../options/linux_options.dart';
import '../../options/macos_options.dart';
import '../../options/windows_options.dart';
import '../../platform_interface/dir_picker_platform.dart';

extension on web.Window {
  external JSPromise<web.FileSystemDirectoryHandle> showDirectoryPicker();
}

bool get _supportsShowDirectoryPicker =>
    (web.window as JSObject).getProperty<JSAny?>('showDirectoryPicker'.toJS) !=
    null;

/// DirPicker implementation for Web.
///
/// Uses the File System Access API (`window.showDirectoryPicker()`).
/// Supported in Chrome/Edge 86+. Throws [UnsupportedError] in Firefox/Safari.
/// Returns a [WebPickedLocation] wrapping the [FileSystemDirectoryHandle].
///
/// Note: [PickedLocation.uri] is always `null` on web — browsers do not
/// expose full filesystem paths. Use [WebPickedLocation.handle] to access
/// directory contents via the File System Access API.
class DirPickerWeb extends DirPickerPlatform {
  static void registerWith(dynamic registrar) {
    DirPickerPlatform.instance = DirPickerWeb();
  }

  @override
  Future<PickedLocation?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
    WindowsOptions? windowsOptions,
  }) async {
    if (!_supportsShowDirectoryPicker) {
      throw UnsupportedError(
        'showDirectoryPicker() is not supported in this browser. '
        'Use Chrome or Edge 86+.',
      );
    }
    try {
      final handle = await web.window.showDirectoryPicker().toDart;
      return WebPickedLocation(handle);
    } catch (e) {
      // AbortError → user cancelled
      if (e.toString().contains('AbortError')) return null;
      rethrow;
    }
  }
}
