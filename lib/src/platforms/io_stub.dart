// Stubs for all non-web platform classes, used when compiling for web.
import '../options/android_options.dart';
import '../options/linux_options.dart';
import '../options/macos_options.dart';
import '../options/windows_options.dart';
import '../location/selected_location.dart';
import '../platform_interface/dir_picker_platform.dart';

class DirPickerWindows extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerWindows();
  @override
  Future<SelectedLocation?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerLinux extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerLinux();
  @override
  Future<SelectedLocation?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerAndroid extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerAndroid();
  @override
  Future<SelectedLocation?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}

class DirPickerDarwin extends DirPickerPlatform {
  static void registerWith() => DirPickerPlatform.instance = DirPickerDarwin();
  @override
  Future<SelectedLocation?> pick(
          {AndroidOptions? androidOptions,
          LinuxOptions? linuxOptions,
          MacosOptions? macosOptions,
          WindowsOptions? windowsOptions}) =>
      throw UnsupportedError('DirPicker is not supported on this platform.');
}
