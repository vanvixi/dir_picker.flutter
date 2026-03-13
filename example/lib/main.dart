import 'package:dir_picker/dir_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Press the button to pick a directory';

  Future<void> _pickDirectory() async {
    try {
      final location = await DirPicker.pick(
        options: switch (defaultTargetPlatform) {
          TargetPlatform.android => PickOptions.android(shouldPersist: true),
          TargetPlatform.macOS => PickOptions.macos(
            acceptLabel: 'Select Directory',
            message: 'Please choose a directory to continue',
          ),
          TargetPlatform.linux => PickOptions.linux(
            title: 'Select a directory',
            acceptLabel: 'Choose',
          ),
          TargetPlatform.windows => PickOptions.windows(
            title: 'Select a directory',
            acceptLabel: 'Choose',
          ),
          _ => null,
        },
      );
      setState(() {
        _result = location != null ? location.toString() : 'Cancelled';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dir Picker Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_result, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDirectory,
                child: const Text('Pick Directory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
