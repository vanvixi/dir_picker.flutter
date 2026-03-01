/// Options for directory picking on Windows.
class WindowsOptions {
  const WindowsOptions({
    this.title = 'Select Directory',
    this.acceptLabel = 'Select',
  });

  /// Title shown in the directory picker dialog.
  ///
  /// Applied via `IFileDialog::SetTitle`.
  final String title;

  /// Label for the confirmation button.
  ///
  /// Applied via `IFileDialog::SetOkButtonLabel`.
  final String acceptLabel;
}
