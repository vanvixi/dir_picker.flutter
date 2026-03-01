// Stubs for all non-web platform classes, used when compiling for web.
import '../platform_interface/dir_picker_platform.dart';

class DirPickerWindows extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerWindows();
  @override
  Future<Uri?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerLinux extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerLinux();
  @override
  Future<Uri?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerAndroid extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerAndroid();
  @override
  Future<Uri?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerDarwin extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerDarwin();
  @override
  Future<Uri?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}
