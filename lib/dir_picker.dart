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
  /// ## Platform behavior
  ///
  /// - **Android**: Uses the Storage Access Framework (`ACTION_OPEN_DOCUMENT_TREE`).
  ///   No manifest permissions required. Set [AndroidOptions.shouldPersist] to
  ///   retain access across reboots via persistable URI permission.
  ///
  /// - **iOS**: Uses `UIDocumentPickerViewController` to let the user pick a folder.
  ///
  /// - **macOS**: Uses `NSOpenPanel`. Requires the
  ///   `com.apple.security.files.user-selected.read-write` entitlement in your
  ///   app's `.entitlements` files. Customize with [MacosOptions].
  ///
  /// - **Windows**: Uses the COM `IFileOpenDialog` interface (Win32).
  ///   Customize the dialog title and button label with [WindowsOptions].
  ///
  /// - **Linux**: Uses the XDG Desktop Portal (`org.freedesktop.portal.FileChooser`)
  ///   with automatic fallback to `zenity` (GNOME) then `kdialog` (KDE).
  ///   Customize with [LinuxOptions].
  ///
  /// - **Web**: Uses the File System Access API (`window.showDirectoryPicker()`).
  ///   Supported on Chrome 86+ and Edge 86+. Throws [UnsupportedError] on
  ///   Firefox and Safari. Returns a [WebSelectedLocation] — [SelectedLocation.uri]
  ///   is always `null` (browsers restrict path access); use
  ///   [WebSelectedLocation.handle] (`FileSystemDirectoryHandle`) to access
  ///   directory contents. Requires `package:web` in your app's dependencies.
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
