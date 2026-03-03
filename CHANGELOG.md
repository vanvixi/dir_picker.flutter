## 0.3.0

* **Breaking:** `DirPicker.pick()` now returns `SelectedLocation?` instead of `Uri?`
* Add `SelectedLocation` abstract class with `NativeLocation` (native platforms) and `WebSelectedLocation` (web)
* Web: return `WebSelectedLocation` wrapping `FileSystemDirectoryHandle` — use `.handle` to access directory contents via the File System Access API
* Web: throw `UnsupportedError` on browsers that do not support `showDirectoryPicker()` (Firefox/Safari)

## 0.2.1

* Fix Swift Package Manager detection on pub.dev

## 0.2.0

* Add Swift Package Manager (SPM) support for iOS and macOS
* **Breaking:** Rename `MacosOptions.prompt` → `MacosOptions.acceptLabel` for consistency with other platforms
* Add `MacosOptions.message` parameter to customize the panel message
* Fix `AndroidOptions.shouldPersist` default value to `false`

## 0.1.0

* Initial version
