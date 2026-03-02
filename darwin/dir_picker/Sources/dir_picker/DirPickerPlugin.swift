#if os(iOS)
import Flutter

public class DirPickerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Native registration — FFI functions are available process-wide.
        // Dart-side initialization (DartApiDl) is done via dartPluginClass.
    }
}
#elseif os(macOS)
import FlutterMacOS

public class DirPickerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Native registration — FFI functions are available process-wide.
        // Dart-side initialization (DartApiDl) is done via dartPluginClass.
    }
}
#endif
