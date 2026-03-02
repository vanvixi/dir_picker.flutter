/// Options for directory picking on Android.
class AndroidOptions {
  const AndroidOptions({this.shouldPersist = false});

  /// Whether to take persistable URI permission so the app can access
  /// the directory across reboots without re-prompting the user.
  ///
  /// Defaults to `false`.
  final bool shouldPersist;
}
