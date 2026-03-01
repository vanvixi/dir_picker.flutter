import 'dart:io';

import '../../platform_interface/dir_picker_platform.dart';

/// DirPicker implementation for Linux.
///
/// Uses CLI tools via [Process.run]:
/// - `zenity` (GNOME/GTK desktops)
/// - `kdialog` (KDE desktops)
class DirPickerLinux extends DirPickerPlatform {
  static void registerWith() {
    DirPickerPlatform.instance = DirPickerLinux();
  }

  @override
  Future<Uri?> pick({bool shouldPersist = true}) async {
    final path = await _pickWithZenity() ?? await _pickWithKdialog();
    if (path == null) return null;
    return Uri.directory(path);
  }

  Future<String?> _pickWithZenity() async {
    try {
      final result = await Process.run('zenity', [
        '--file-selection',
        '--directory',
        '--title=Select Directory',
      ]);
      if (result.exitCode != 0) return null;
      final path = (result.stdout as String).trim();
      return path.isEmpty ? null : path;
    } on ProcessException {
      return null;
    }
  }

  Future<String?> _pickWithKdialog() async {
    try {
      final result = await Process.run('kdialog', [
        '--getexistingdirectory',
        Platform.environment['HOME'] ?? '/',
      ]);
      if (result.exitCode != 0) return null;
      final path = (result.stdout as String).trim();
      return path.isEmpty ? null : path;
    } on ProcessException {
      return null;
    }
  }
}
