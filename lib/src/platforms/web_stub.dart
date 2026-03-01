// Stub for DirPickerWeb, used when compiling for non-web (IO) platforms.
import '../platform_interface/dir_picker_platform.dart';

class DirPickerWeb extends DirPickerPlatform {
  static void registerWith(dynamic registrar) =>
      DirPickerPlatform.instance = DirPickerWeb();
  @override
  Future<Uri?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}
