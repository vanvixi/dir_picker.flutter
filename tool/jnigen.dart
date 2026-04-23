// ignore_for_file: avoid_print

import 'dart:io';

import 'package:jnigen/jnigen.dart';

/// Generates JNI bindings for the Android native classes.
///
/// Run with:
///   dart run tool/jnigen.dart
void main(List<String> args) async {
  final packageRoot = Platform.script.resolve('../');

  // Step 1 — Compile plugin Kotlin classes first. This avoids a bootstrap
  // issue where Flutter's Dart build may reference bindings that are about to
  // be regenerated.
  print('Running Gradle dir_picker:compileDebugKotlin in example/android/...');

  final result = await Process.run(
    './gradlew',
    ['dir_picker:compileDebugKotlin'],
    workingDirectory: packageRoot.resolve('example/android/').toFilePath(),
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    throw Exception('Gradle dir_picker:compileDebugKotlin failed');
  }

  // Step 2 — Generate JNI bindings
  print('Generating JNI bindings...');
  await generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve(
            'lib/src/platforms/android/native_bindings.g.dart',
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
