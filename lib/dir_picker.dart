import 'src/platform_interface/dir_picker_platform.dart';

export 'src/options/android_options.dart';
export 'src/options/macos_options.dart';

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
  /// [androidOptions]: Android-specific options (e.g. persistent URI permission).
  /// [macosOptions]: macOS-specific options (e.g. panel prompt and message text).
  ///
  /// On web, the returned [Uri] path is the selected directory name only —
  /// browsers do not expose full filesystem paths.
  static Future<Uri?> pick({
    AndroidOptions? androidOptions,
    MacosOptions? macosOptions,
  }) =>
      DirPickerPlatform.instance.pick(
        androidOptions: androidOptions,
        macosOptions: macosOptions,
      );
}
