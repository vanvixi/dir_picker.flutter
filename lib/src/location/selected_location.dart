/// Base class for the result of a directory pick operation.
abstract class SelectedLocation {
  /// The URI of the selected directory.
  ///
  /// Returns `null` on web — browsers do not expose full filesystem paths
  /// for security reasons.
  Uri? get uri;
}

/// A [SelectedLocation] on native platforms (Android, iOS, macOS, Windows, Linux).
class NativeLocation extends SelectedLocation {
  NativeLocation(this._uri);

  final Uri _uri;

  @override
  Uri get uri => _uri;

  @override
  String toString() => 'NativeLocation($uri)';
}
