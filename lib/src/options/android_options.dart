/// Options for directory picking on Android.
class AndroidOptions {
  const AndroidOptions({this.shouldPersist = true});

  /// Whether to take persistable URI permission so the app can access
  /// the directory across reboots without re-prompting the user.
  ///
  /// Defaults to `true`.
  final bool shouldPersist;
}
