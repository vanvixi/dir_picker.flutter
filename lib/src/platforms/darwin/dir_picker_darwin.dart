import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import '../../location/picked_location.dart';
import '../../options/pick_options.dart';
import '../../platform_interface/dir_picker_platform.dart';
import 'native.g.dart' as native;

/// DirPicker implementation for Apple platforms (iOS and macOS).
///
/// Uses FFI with DartApiDl NativePort for async directory picking.
class DirPickerDarwin extends DirPickerPlatform {
  DirPickerDarwin() {
    final dylib = DynamicLibrary.process();
    _bindings = native.DirPickerBindings(dylib);

    final result = _bindings.initDartApiDl(
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
  Future<PickedLocation?> pick({PickOptions? options}) async {
    final completer = Completer<PickedLocation?>();
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
          completer.complete(NativePickedLocation(uri));
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

    // Allocate C strings for macOS options; Swift copies them synchronously
    // before dispatching to the main queue, so freeing after the call is safe.
    final opts = options is MacosOptions ? options : const MacosOptions();
    final acceptLabelPtr = opts.acceptLabel.toNativeUtf8().cast<Char>();
    final messagePtr = opts.message.toNativeUtf8().cast<Char>();

    try {
      _bindings.pick(port.sendPort.nativePort, acceptLabelPtr, messagePtr);
    } finally {
      calloc.free(acceptLabelPtr);
      calloc.free(messagePtr);
    }

    return completer.future;
  }
}
