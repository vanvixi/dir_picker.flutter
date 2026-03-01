/// Options for directory picking on Linux.
class LinuxOptions {
  const LinuxOptions({
    this.title = 'Select Directory',
    this.acceptLabel = 'Select',
  });

  /// Title shown in the directory picker dialog.
  ///
  /// Applied to XDG Desktop Portal, zenity, and kdialog.
  final String title;

  /// Label for the confirmation button.
  ///
  /// Applied to XDG Desktop Portal (via `accept_label`) and zenity (via `--ok-label`).
  /// Not supported by kdialog.
  final String acceptLabel;
}
