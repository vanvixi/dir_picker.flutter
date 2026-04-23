import '../location/file_system_entry.dart';
import '../location/picked_location.dart';
import '../options/pick_options.dart';

abstract class DirPickerPlatform {
  static DirPickerPlatform? _instance;

  static DirPickerPlatform get instance {
    assert(
      _instance != null,
      'DirPickerPlatform.instance has not been set. '
      'Ensure the plugin is correctly registered.',
    );
    return _instance!;
  }

  static set instance(DirPickerPlatform platform) => _instance = platform;

  Future<PickedLocation?> pick({PickOptions? options});

  Future<List<FileSystemEntry>> listEntries(
    PickedLocation location, {
    bool recursive = false,
  });
}
