import 'dart:async';

import '../../options/android_options.dart';
import '../../options/linux_options.dart';
import '../../options/macos_options.dart';
import '../../options/windows_options.dart';
import '../../location/selected_location.dart';
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
  Future<SelectedLocation?> pick({
    AndroidOptions? androidOptions,
    LinuxOptions? linuxOptions,
    MacosOptions? macosOptions,
    WindowsOptions? windowsOptions,
  }) {
    final completer = Completer<SelectedLocation?>();

    final callback = native.PickerCallback.implement(
      native.$PickerCallback(
        onSuccess: (jUri) {
          final uri = Uri.parse(jUri.toDartString());
          jUri.release();
          completer.complete(NativeLocation(uri));
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
