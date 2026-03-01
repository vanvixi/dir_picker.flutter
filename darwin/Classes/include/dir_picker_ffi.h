#ifndef dir_picker_ffi_h
#define dir_picker_ffi_h

#include <stdint.h>

/// Initialize Dart API for NativePort communication.
/// Must be called before using dir_picker_pick.
///
/// @param data Pointer from NativeApi.initializeApiDLData
/// @return 0 on success, -1 on failure
intptr_t dir_picker_init_dart_api_dl(void* data);

/// Show a directory picker dialog and report the result via NativePort.
///
/// Messages sent to native_port:
/// - Success:    [0, directoryUri]
/// - Cancelled:  [1]
/// - Error:      [2, errorCode, errorMessage]
///
/// @param native_port Dart NativePort for result reporting
void dir_picker_pick(int64_t native_port);

#endif /* dir_picker_ffi_h */
