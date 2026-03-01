import 'dart:io';

import 'package:dbus/dbus.dart';

import '../../platform_interface/dir_picker_platform.dart';

/// Thrown when a picker method is not available on the current system
/// (e.g. portal daemon not running, CLI tool not installed).
/// Distinct from user cancellation, which returns null.
class _PickerUnavailableException implements Exception {}

/// DirPicker implementation for Linux.
///
/// Uses the following methods in order of priority:
/// 1. XDG Desktop Portal (`org.freedesktop.portal.FileChooser`) via D-Bus —
///    works on all desktop environments including sandboxed apps (Flatpak/Snap).
/// 2. `zenity` CLI (GNOME/GTK desktops) — fallback if portal is unavailable.
/// 3. `kdialog` CLI (KDE desktops) — final fallback.
///
/// Each method throws [_PickerUnavailableException] if the tool is not present,
/// allowing the next fallback to be tried. A null return always means the user
/// cancelled — the fallback chain stops immediately.
class DirPickerLinux extends DirPickerPlatform {
  static void registerWith() {
    DirPickerPlatform.instance = DirPickerLinux();
  }

  @override
  Future<Uri?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
  }) async {
    final opts = linuxOptions ?? const LinuxOptions();
    for (final picker in [
      () => _pickWithPortal(opts),
      () => _pickWithZenity(opts),
      () => _pickWithKdialog(opts),
    ]) {
      try {
        return await picker();
      } on _PickerUnavailableException {
        continue;
      }
    }
    return null;
  }

  Future<Uri?> _pickWithPortal(LinuxOptions opts) async {
    DBusClient? client;
    try {
      client = DBusClient.session();

      final object = DBusRemoteObject(
        client,
        name: 'org.freedesktop.portal.Desktop',
        path: DBusObjectPath('/org/freedesktop/portal/desktop'),
      );

      final token = 'dir_picker_${DateTime.now().millisecondsSinceEpoch}';

      final result = await object.callMethod(
        'org.freedesktop.portal.FileChooser',
        'OpenFile',
        [
          DBusString(''), // parent_window
          DBusString(opts.title), // title
          DBusDict.stringVariant({
            'handle_token': DBusString(token),
            'directory': DBusBoolean(true),
            'modal': DBusBoolean(true),
            'accept_label': DBusString(opts.acceptLabel),
          }),
        ],
        replySignature: DBusSignature('o'),
      );

      final handlePath = result.returnValues[0].asObjectPath();

      final handleObject = DBusRemoteObject(
        client,
        name: 'org.freedesktop.portal.Desktop',
        path: handlePath,
      );

      final signals = DBusRemoteObjectSignalStream(
        object: handleObject,
        interface: 'org.freedesktop.portal.Request',
        name: 'Response',
      );

      await for (final signal in signals) {
        final response = signal.values[0].asUint32();
        if (response != 0) return null; // 1=cancelled, 2=error

        final results = signal.values[1].asStringVariantDict();
        final uris = results['uris']?.asStringArray().toList();
        if (uris == null || uris.isEmpty) return null;

        final uri = Uri.parse(uris.first);
        return Uri.directory(uri.toFilePath());
      }

      return null;
    } catch (_) {
      throw _PickerUnavailableException();
    } finally {
      await client?.close();
    }
  }

  Future<Uri?> _pickWithZenity(LinuxOptions opts) async {
    try {
      final result = await Process.run('zenity', [
        '--file-selection',
        '--directory',
        '--title=${opts.title}',
        '--ok-label=${opts.acceptLabel}',
      ]);
      if (result.exitCode != 0) return null;
      final path = (result.stdout as String).trim();
      return path.isEmpty ? null : Uri.directory(path);
    } on ProcessException {
      throw _PickerUnavailableException();
    }
  }

  Future<Uri?> _pickWithKdialog(LinuxOptions opts) async {
    try {
      final result = await Process.run('kdialog', [
        '--title',
        opts.title,
        '--getexistingdirectory',
        Platform.environment['HOME'] ?? '/',
      ]);
      if (result.exitCode != 0) return null;
      final path = (result.stdout as String).trim();
      return path.isEmpty ? null : Uri.directory(path);
    } on ProcessException {
      throw _PickerUnavailableException();
    }
  }
}
