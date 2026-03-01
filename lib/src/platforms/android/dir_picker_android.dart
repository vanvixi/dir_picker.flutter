import 'dart:async';

import '../../platform_interface/dir_picker_platform.dart';
import 'native.g.dart' as native;

/// DirPicker implementation for Android.
///
/// Uses JNI via the jni package. [PickerCallback.implement()] is backed by
/// a RawReceivePort (native port) internally — no manual port management needed.
class DirPickerAndroid extends DirPickerPlatform {
  static void registerWith() {
    DirPickerPlatform.instance = DirPickerAndroid();
  }

  @override
  Future<Uri?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
    WindowsOptions? windowsOptions,
  }) {
    final completer = Completer<Uri?>();

    final callback = native.PickerCallback.implement(
      native.$PickerCallback(
        onSuccess: (jUri) {
          final uri = Uri.parse(jUri.toDartString());
          jUri.release();
          completer.complete(uri);
        },
        onCancelled: () => completer.complete(null),
        onError: (jCode, jMessage) {
          final code = jCode.toDartString();
          final msg = jMessage.toDartString();
          jCode.release();
          jMessage.release();
          completer.completeError(Exception('$code: $msg'));
        },
      ),
    );

    // Non-blocking: Kotlin launches coroutine internally
    native.DirPicker.pick(androidOptions?.shouldPersist ?? true, callback);

    return completer.future.whenComplete(() => callback.release());
  }
}
