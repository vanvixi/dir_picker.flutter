import 'src/platform_interface/dir_picker_platform.dart';

export 'src/platform_interface/dir_picker_platform.dart';

// IO platforms (Windows, Linux, Android, Darwin) — or their stubs on web.
export 'src/platforms/io_platforms.dart'
    if (dart.library.html) 'src/platforms/io_stub.dart';

// Web platform — or its stub on non-web platforms.
export 'src/platforms/web/dir_picker_web.dart'
    if (dart.library.io) 'src/platforms/web_stub.dart';

class DirPicker {
  DirPicker._();

  /// Picks a directory and returns its [Uri], or `null` if the user cancelled.
  ///
  /// [shouldPersist] (Android only): whether to take persistable URI permission
  /// so the app can access the directory across reboots.
  ///
  /// On web, the returned [Uri] path is the selected directory name only —
  /// browsers do not expose full filesystem paths.
  static Future<Uri?> pick({bool shouldPersist = true}) =>
      DirPickerPlatform.instance.pick(shouldPersist: shouldPersist);
}
