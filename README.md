## dir_picker

<p align="left">
  <a href="https://github.com/vanvixi/dir_picker.flutter"><img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-blue.svg" alt="Platform"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A Flutter plugin for picking a directory across all platforms using native system dialogs. Returns a `PickedLocation?` — null if the user cancelled.

## Features

- 📁 **All Platforms** – Android, iOS, macOS, Windows, Linux, and Web
- ⚡ **Native Performance** – Powered by FFI (iOS/macOS/Windows) and JNI (Android) for near-zero overhead
- 🎨 **Customizable Dialogs** – Platform-specific options for title, button labels, and more
- 🔗 **Persistent Permissions** – Android SAF persistent URI access across reboots
- 🐧 **Linux Portals** – XDG Desktop Portal with zenity/kdialog fallback

If you want to say thank you, star us on GitHub or like us on pub.dev.

## Installation

First, follow the [package installation instructions](https://pub.dev/packages/dir_picker/install) and add
`dir_picker` to your app.

## Quick Start

### Platform Setup

<details>
<summary><b>Android Configuration</b></summary>

**Supported:** API 21+ (Android 5.0+)

No configuration needed. The plugin uses the Storage Access Framework (`Intent.ACTION_OPEN_DOCUMENT_TREE`), which grants URI access through the system picker UI — no manifest permissions required.

</details>

<details>
<summary><b>iOS Configuration</b></summary>

**Supported:** iOS 13.0+

No configuration needed. The plugin uses `UIDocumentPickerViewController`, which is available without extra entitlements.

</details>

<details>
<summary><b>macOS Configuration</b></summary>

**Supported:** macOS 10.15+

Add the following entitlement to `macos/Runner/Release.entitlements` and `macos/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

</details>

<details>
<summary><b>Windows Configuration</b></summary>

**Supported:** Windows 10+

No configuration needed. The plugin uses the native `IFileOpenDialog` COM API.

</details>

<details>
<summary><b>Linux Configuration</b></summary>

The plugin tries the following dialog backends in order:

1. **XDG Desktop Portal** – Works on all modern desktop environments via D-Bus (`org.freedesktop.portal.FileChooser`)
2. **zenity** – GNOME fallback
3. **kdialog** – KDE fallback

If none are available, the pick call throws. To install a fallback manually:

```bash
# GNOME
sudo apt install zenity

# KDE
sudo apt install kdialog
```

</details>

<details>
<summary><b>Web Configuration</b></summary>

No configuration needed. The plugin uses the [File System Access API](https://developer.mozilla.org/en-US/docs/Web/API/Window/showDirectoryPicker).

**Browser support:** Chrome 86+ and Edge 86+. Not supported in Firefox or Safari.

> **Note:** On web, `pick()` returns a `WebPickedLocation` wrapping a `FileSystemDirectoryHandle`. Use `.handle` to access directory contents via the File System Access API. `PickedLocation.uri` is always `null` on web — browsers do not expose full filesystem paths. Requires `package:web` in your app's dependencies to work with the handle directly.

</details>

### Basic Usage

```dart
import 'package:dir_picker/dir_picker.dart';

final PickedLocation? location = await DirPicker.pick();

if (location == null) {
  print('Cancelled');
} else if (location is WebPickedLocation) {
  // Web: use handle to access directory contents via File System Access API
  // Requires package:web in your app's dependencies
  final handle = location.handle; // FileSystemDirectoryHandle
  print('Selected directory: ${location.name}');
} else {
  // Native (Android, iOS, macOS, Windows, Linux)
  print('Selected: ${location.uri}');
}
```

## Platform Options

Each platform exposes its own options class for customizing the dialog. Pass them to `DirPicker.pick()`:

```dart
final location = await DirPicker.pick(
  androidOptions: const AndroidOptions(shouldPersist: true),
  macosOptions: const MacosOptions(acceptLabel: 'Choose', message: 'Select a project folder'),
  linuxOptions: const LinuxOptions(title: 'Select Folder', acceptLabel: 'Choose'),
  windowsOptions: const WindowsOptions(title: 'Select Folder', acceptLabel: 'Choose'),
);
```

### AndroidOptions

| Parameter       | Type   | Default | Description                                                                                                    |
|-----------------|--------|---------|----------------------------------------------------------------------------------------------------------------|
| `shouldPersist` | `bool` | `true`  | Take persistable URI permission so the app retains access across reboots (SAF `takePersistableUriPermission`). |

### MacosOptions

| Parameter     | Type     | Default                | Description                                                      |
|---------------|----------|------------------------|------------------------------------------------------------------|
| `acceptLabel` | `String` | `'Select'`             | Label for the confirmation button (`NSOpenPanel.prompt`).        |
| `message`     | `String` | `'Choose a directory'` | Descriptive text shown inside the panel (`NSOpenPanel.message`). |

### LinuxOptions

| Parameter     | Type     | Default              | Description                                                     |
|---------------|----------|----------------------|-----------------------------------------------------------------|
| `title`       | `String` | `'Select Directory'` | Window title of the dialog.                                     |
| `acceptLabel` | `String` | `'Select'`           | Label for the confirmation button (XDG Portal and zenity only). |

### WindowsOptions

| Parameter     | Type     | Default              | Description                                                          |
|---------------|----------|----------------------|----------------------------------------------------------------------|
| `title`       | `String` | `'Select Directory'` | Window title of the dialog (`IFileDialog::SetTitle`).                |
| `acceptLabel` | `String` | `'Select'`           | Label for the confirmation button (`IFileDialog::SetOkButtonLabel`). |

## Core Concepts

### Return value

| Result                 | Meaning                                                                                           |
|------------------------|---------------------------------------------------------------------------------------------------|
| `NativePickedLocation` | Native platforms — use `.uri` to get the selected directory URI.                                  |
| `WebPickedLocation`    | Web — use `.handle` (`FileSystemDirectoryHandle`) to access directory contents. `.uri` is `null`. |
| `null`                 | The user cancelled.                                                                               |

### Native Mechanisms

| Platform | Mechanism                                        |
|----------|--------------------------------------------------|
| Android  | SAF (`Intent.ACTION_OPEN_DOCUMENT_TREE`) via JNI |
| iOS      | `UIDocumentPickerViewController` via FFI         |
| macOS    | `NSOpenPanel` via FFI                            |
| Windows  | `IFileOpenDialog` (COM) via pure Dart FFI        |
| Linux    | XDG Desktop Portal → zenity → kdialog            |
| Web      | `window.showDirectoryPicker()` (JS interop)      |

## Common Use Cases

### Simple directory pick (native)

```dart
final location = await DirPicker.pick();
if (location != null) {
  print('Selected: ${location.uri}');
}
```

### Simple directory pick (web)

```dart
import 'package:dir_picker/dir_picker.dart';
import 'package:web/web.dart' as web; // required to use FileSystemDirectoryHandle

final location = await DirPicker.pick();
if (location is WebPickedLocation) {
  final web.FileSystemDirectoryHandle handle = location.handle;
  // list files, read contents, etc.
}
```

### Custom dialog labels

```dart
final location = await DirPicker.pick(
  macosOptions: const MacosOptions(
    acceptLabel: 'Use This Folder',
    message: 'Select the folder to import from',
  ),
  linuxOptions: const LinuxOptions(
    title: 'Import Folder',
    acceptLabel: 'Use This Folder',
  ),
  windowsOptions: const WindowsOptions(
    title: 'Import Folder',
    acceptLabel: 'Use This Folder',
  ),
);
```

### Android — enable persistent permission

```dart
final location = await DirPicker.pick(
  androidOptions: const AndroidOptions(shouldPersist: true),
);
```

## API Reference

### `DirPicker.pick`

```dart
static Future<PickedLocation?> pick({
  AndroidOptions? androidOptions,
  LinuxOptions? linuxOptions,
  MacosOptions? macosOptions,
  WindowsOptions? windowsOptions,
})
```

Returns a `PickedLocation` (either `NativePickedLocation` or `WebPickedLocation`), or `null` if the user cancelled.

## Platform Support

| Android | iOS | macOS | Windows | Linux | Web |
| :-----: | :-: | :---: | :-----: | :---: | :-: |
|   ✅    | ✅  |  ✅   |   ✅    |  ✅   | ✅  |

**Minimum versions:**

- Flutter ≥ 3.3.0
- Dart SDK ≥ 3.6.0
- Kotlin 2.1.0
- Swift 5.9
- Android API 21+
- iOS 13.0+
- macOS 10.15+
- Windows 10+
- Web: Chrome/Edge 86+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License — see [LICENSE](LICENSE) file for details.
