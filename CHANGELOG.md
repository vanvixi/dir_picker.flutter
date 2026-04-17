## 0.4.0

* Migrate `jnigen.yaml` and `ffigen.yaml` to Dart scripts in `tool/` directory for better maintainability
* Update `jni` dependency to `1.0.0`
* Update `jnigen` dev dependency to `0.16.0`
* Fix `ffigen` configuration to support latest API changes in `ffigen 20.1`

## 0.3.1

* Add README usage examples for handling `WebSelectedLocation` on web and `NativeLocation` on native

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
