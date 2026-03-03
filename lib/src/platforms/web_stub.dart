// Stub for DirPickerWeb, used when compiling for non-web (IO) platforms.
import '../options/android_options.dart';
import '../options/linux_options.dart';
import '../options/macos_options.dart';
import '../options/windows_options.dart';
import '../location/selected_location.dart';
import '../platform_interface/dir_picker_platform.dart';

class DirPickerWeb extends DirPickerPlatform {
  static void registerWith(dynamic registrar) =>
      DirPickerPlatform.instance = DirPickerWeb();
  @override
  Future<SelectedLocation?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}
