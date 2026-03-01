package com.vanvixi.dir_picker

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Entry point for directory picking, callable from Dart via JNI.
 *
 * [pickerHandler] is injected by [DirPickerPlugin] when an Activity is available.
 * [pick] launches a coroutine on IO dispatcher so it never blocks the Dart thread.
 */
class DirPicker {
    companion object {
        /**
         * Set by [DirPickerPlugin] when Activity becomes available.
         * Cleared when Activity is detached.
         */
        @Volatile
        var pickerHandler: PickerHandler? = null

        /**
         * Shows the directory picker and delivers the result via [callback].
         *
         * Non-blocking: launches a coroutine internally so Dart can return
         * immediately and await the callback.
         *
         * @param shouldPersist Whether to take persistable URI permission (Android only)
         * @param callback Receives onSuccess, onCancelled, or onError
         */
        @JvmStatic
        fun pick(shouldPersist: Boolean, callback: PickerCallback) {
            CoroutineScope(Dispatchers.IO).launch {
                val handler = pickerHandler
                if (handler == null) {
                    callback.onError("NO_ACTIVITY", "No Activity available to show directory picker")
                    return@launch
                }

                try {
                    val uri = handler.pick(shouldPersist)
                    if (uri != null) {
                        callback.onSuccess(uri)
                    } else {
                        callback.onCancelled()
                    }
                } catch (e: Exception) {
                    callback.onError("PICKER_ERROR", e.message ?: "Unknown error")
                }
            }
        }
    }
}
