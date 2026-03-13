import 'package:web/web.dart' as web;

import 'picked_location.dart';

/// A [PickedLocation] on the web platform.
///
/// Wraps a [FileSystemDirectoryHandle] from the File System Access API.
/// Use [handle] to list or read files within the selected directory.
///
/// [uri] is always `null` — browsers restrict access to the full filesystem
/// path for security reasons. Use [name] to get the directory name.
class WebPickedLocation extends PickedLocation {
  WebPickedLocation(this.handle);

  final web.FileSystemDirectoryHandle handle;

  /// The name of the selected directory.
  String get name => handle.name;

  @override
  Uri? get uri => null;

  @override
  String toString() => 'WebPickedLocation(name: $name)';
}
