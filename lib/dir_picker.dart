import 'src/options/android_options.dart';
import 'src/options/linux_options.dart';
import 'src/options/macos_options.dart';
import 'src/options/windows_options.dart';
import 'src/location/selected_location.dart';
import 'src/platform_interface/dir_picker_platform.dart';

export 'src/options/android_options.dart';
export 'src/options/linux_options.dart';
export 'src/options/macos_options.dart';
export 'src/options/windows_options.dart';
export 'src/location/selected_location.dart';
export 'src/platform_interface/dir_picker_platform.dart' show DirPickerPlatform;

// IO platforms (Windows, Linux, Android, Darwin) — or their stubs on web.
export 'src/platforms/io_platforms.dart'
    if (dart.library.html) 'src/platforms/io_stub.dart';

// Web platform — or its stub on non-web platforms.
export 'src/platforms/web/dir_picker_web.dart'
    if (dart.library.io) 'src/platforms/web_stub.dart';

// WebSelectedLocation — web only, stub on native.
export 'src/location/web_selected_location.dart'
    if (dart.library.io) 'src/location/web_selected_location_stub.dart';

class DirPicker {
  DirPicker._();

  /// Picks a directory and returns a [SelectedLocation], or `null` if cancelled.
  ///
  /// On native platforms, [SelectedLocation.uri] contains the full directory URI.
  ///
  /// On web, returns a [WebSelectedLocation]. [SelectedLocation.uri] is `null`
  /// (browsers restrict path access). Use [WebSelectedLocation.handle] to
  /// access directory contents via the File System Access API — requires
  /// `package:web` in your app's dependencies to work with
  /// [web.FileSystemDirectoryHandle] directly.
  ///
  /// Throws [UnsupportedError] if the browser does not support
  /// `showDirectoryPicker()` (Firefox/Safari).
  static Future<SelectedLocation?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
    WindowsOptions? windowsOptions,
  }) =>
      DirPickerPlatform.instance.pick(
        androidOptions: androidOptions,
        linuxOptions: linuxOptions,
        macosOptions: macosOptions,
        windowsOptions: windowsOptions,
      );
}
