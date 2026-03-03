import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../platform_interface/dir_picker_platform.dart';

extension on web.Window {
  external JSPromise<web.FileSystemDirectoryHandle> showDirectoryPicker();
}

/// DirPicker implementation for Web.
///
/// Uses the File System Access API (`window.showDirectoryPicker()`).
/// Supported in Chrome/Edge. Throws [UnsupportedError] in Firefox/Safari.
/// Returns a [Uri] whose path is the selected directory name (browsers do not
/// expose the full filesystem path for security reasons).
class DirPickerWeb extends DirPickerPlatform {
  static void registerWith(dynamic registrar) {
    DirPickerPlatform.instance = DirPickerWeb();
  }

  @override
  Future<Uri?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
    WindowsOptions? windowsOptions,
  }) async {
    try {
      final handle = await web.window.showDirectoryPicker().toDart;
      return Uri(path: handle.name);
    } catch (e) {
      // AbortError → user cancelled; NotSupportedError → browser unsupported
      final msg = e.toString();
      if (msg.contains('AbortError') || msg.contains('cancelled')) return null;
      rethrow;
    }
  }
}
