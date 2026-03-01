/// Options for directory picking on macOS.
class MacosOptions {
  const MacosOptions({
    this.prompt = 'Select',
    this.message = 'Choose a directory',
  });

  /// Label for the confirmation button in the directory picker panel.
  final String prompt;

  /// Descriptive message shown in the directory picker panel.
  final String message;
}
