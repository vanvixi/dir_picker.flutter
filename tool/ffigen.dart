import 'dart:io';

import 'package:ffigen/ffigen.dart';

void main() {
  // Using Platform.script.resolve('../') as per your documentation
  // to ensure paths are relative to the project root.
  final packageRoot = Platform.script.resolve('../');

  FfiGenerator(
    // 1. Output configuration
    output: Output(
      dartFile: packageRoot.resolve('lib/src/platforms/darwin/native.g.dart'),
      preamble: '''
// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
''',
      style: const DynamicLibraryBindings(
        wrapperName: 'DirPickerBindings',
        wrapperDocComment: 'Bindings for Darwin (iOS/macOS) dir_picker_ffi.h.',
      ),
    ),

    // 2. Header configuration
    headers: Headers(
      entryPoints: [
        packageRoot.resolve(
            'darwin/dir_picker/Sources/dir_picker/include/dir_picker_ffi.h'),
      ],
    ),

    // 3. Declaration filters
    functions: Functions.includeSet({
      'dir_picker_init_dart_api_dl',
      'dir_picker_pick',
    }),
  ).generate();

  // ignore: avoid_print
  print('Generated Darwin bindings successfully.');
}
