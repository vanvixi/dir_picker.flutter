# dir_picker

A Flutter plugin for picking a directory across all platforms — Android, iOS, macOS, Windows, Linux, and Web.

Returns a `Uri?` (null if the user cancelled).

| Platform | Mechanism                                   |
|----------|---------------------------------------------|
| Android  | SAF (Storage Access Framework) via JNI      |
| iOS      | `UIDocumentPickerViewController` via FFI    |
| macOS    | `NSOpenPanel` via FFI                       |
| Windows  | `IFileOpenDialog` (COM) via pure Dart FFI   |
| Linux    | `zenity` / `kdialog` CLI                    |
| Web      | `window.showDirectoryPicker()` (JS interop) |

---

## Installation

```yaml
dependencies:
  dir_picker: ^0.0.1
```

---

## Usage

```dart
import 'package:dir_picker/dir_picker.dart';

final Uri? uri = await DirPicker.pick(shouldPersist: true);

if (uri != null) {
  print('Selected: $uri');
} else {
  print('Cancelled');
}
```

### Parameter

| Parameter       | Type   | Default | Description                                                                                 |
|-----------------|--------|---------|---------------------------------------------------------------------------------------------|
| `shouldPersist` | `bool` | `true`  | **Android only.** Take persistable URI permission so the app retains access across reboots. |

### Return value

- Returns a `Uri` on success.
- Returns `null` if the user cancelled.
- On **Web**, the `Uri` path contains only the directory name (browsers do not expose full filesystem paths).

---

## Platform setup

### Android

No additional setup required. The plugin uses the Storage Access Framework (`Intent.ACTION_OPEN_DOCUMENT_TREE`), which grants URI access through the system picker UI without any manifest permissions.

### iOS

No additional setup required. The plugin uses `UIDocumentPickerViewController` which is available without extra entitlements.

### macOS

Add the following entitlement to `macos/Runner/Release.entitlements` and `macos/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

### Windows

No additional setup required. The plugin uses the native `IFileOpenDialog` COM API.

### Linux

Requires either `zenity` (GNOME) or `kdialog` (KDE) to be installed:

```bash
# GNOME
sudo apt install zenity

# KDE
sudo apt install kdialog
```

### Web

No additional setup required. The plugin uses the [File System Access API](https://developer.mozilla.org/en-US/docs/Web/API/Window/showDirectoryPicker). Supported in Chrome 86+ and Edge 86+. Not supported in Firefox or Safari.

---

## Example

```dart
import 'package:flutter/material.dart';
import 'package:dir_picker/dir_picker.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _result = 'No directory selected';

  Future<void> _pick() async {
    final uri = await DirPicker.pick(shouldPersist: true);
    setState(() {
      _result = uri?.toString() ?? 'Cancelled';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_result),
        ElevatedButton(
          onPressed: _pick,
          child: const Text('Pick Directory'),
        ),
      ],
    );
  }
}
```

---

## Platform support

| Android | iOS | macOS | Windows | Linux | Web |
|:-------:|:---:|:-----:|:-------:|:-----:|:---:|
|    ✅    |  ✅  |   ✅   |    ✅    |   ✅   |  ✅  |

**Minimum versions:**
- Flutter `>=3.3.0`
- Dart SDK `>=3.6.0`
- Kotlin `2.1.0`
- Android: API 21+
- iOS: 13.0+
- macOS: 10.15+
- Windows: 10+
- Web: Chrome 86+ / Edge 86+

---
