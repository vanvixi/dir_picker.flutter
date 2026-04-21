// ignore_for_file: avoid_print

import 'dart:io';

import 'package:jnigen/jnigen.dart';

/// Generates JNI bindings for the Android native classes.
///
/// Run with:
///   dart run tool/jnigen.dart
void main(List<String> args) async {
  final packageRoot = Platform.script.resolve('../');

  // Step 1 — Build example APK first
  print('Running flutter build apk --debug in example/...');

  final result = await Process.run(
    'flutter',
    ['build', 'apk', '--debug'],
    workingDirectory: packageRoot.resolve('example/').toFilePath(),
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    throw Exception('flutter build apk failed');
  }

  // Step 2 — Generate JNI bindings
  print('Generating JNI bindings...');
  await generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve(
            'lib/src/platforms/android/native.g.dart',
          ),
          structure: OutputStructure.singleFile,
        ),
      ),
      sourcePath: [
        packageRoot.resolve(
          'android/src/main/kotlin/com/vanvixi/dir_picker/',
        ),
      ],
      classPath: [
        packageRoot.resolve(
          'example/build/dir_picker/tmp/kotlin-classes/debug',
        ),
      ],
      classes: [
        'com.vanvixi.dir_picker.DirPicker',
        'com.vanvixi.dir_picker.PickerCallback',
      ],
    ),
  );

  print('JNI bindings generated successfully.');
}
