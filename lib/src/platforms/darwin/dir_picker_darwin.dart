import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import '../../platform_interface/dir_picker_platform.dart';
import 'native.g.dart' as native;

/// DirPicker implementation for Apple platforms (iOS and macOS).
///
/// Uses FFI with DartApiDl NativePort for async directory picking.
class DirPickerDarwin extends DirPickerPlatform {
  DirPickerDarwin() {
    final dylib = DynamicLibrary.process();
    _bindings = native.DirPickerBindings(dylib);

    final result = _bindings.dir_picker_init_dart_api_dl(
      NativeApi.initializeApiDLData,
    );
    if (result != 0) {
      throw StateError('Failed to initialize Dart API DL (code: $result)');
    }
  }

  static void registerWith() {
    DirPickerPlatform.instance = DirPickerDarwin();
  }

  late final native.DirPickerBindings _bindings;

  @override
  Future<Uri?> pick({AndroidOptions? androidOptions}) async {
    final completer = Completer<Uri?>();
    final port = ReceivePort();

    port.listen((message) {
      port.close();

      if (message is! List || message.isEmpty) {
        completer.completeError(StateError('Invalid message format'));
        return;
      }

      final type = message[0] as int;
      switch (type) {
        case 0: // Success
          final uri = Uri.parse(message[1] as String);
          completer.complete(uri);
        case 1: // Cancelled
          completer.complete(null);
        case 2: // Error
          final code = message[1] as String;
          final msg = message[2] as String;
          completer.completeError(Exception('$code: $msg'));
        default:
          completer.completeError(
            StateError('Unknown message type: $type'),
          );
      }
    });

    _bindings.dir_picker_pick(port.sendPort.nativePort);

    return completer.future;
  }
}
