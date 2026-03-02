/// Options for directory picking on macOS.
class MacosOptions {
  const MacosOptions({
    this.acceptLabel = 'Select',
    this.message = 'Choose a directory',
  });

  /// Label for the confirmation button.
  ///
  /// Applied via `NSOpenPanel.prompt`.
  final String acceptLabel;

  /// Descriptive message shown inside the panel above the browser.
  ///
  /// Applied via `NSOpenPanel.message`. macOS-specific — no equivalent on other platforms.
  final String message;
}
