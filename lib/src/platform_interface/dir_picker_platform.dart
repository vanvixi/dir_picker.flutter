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

  Future<Uri?> pick({bool shouldPersist = true});
}
