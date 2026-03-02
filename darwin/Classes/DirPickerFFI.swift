import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@_implementationOnly import DartApiDl

// MARK: - Init

@_cdecl("dir_picker_init_dart_api_dl")
public func dirPickerInitDartApiDL(_ data: UnsafeMutableRawPointer?) -> Int {
    guard let data = data else { return -1 }
    return Dart_InitializeApiDL(data)
}

// MARK: - Directory Picker

#if os(iOS)
private var activePickerHelper: DocumentPickerHelper?
private let pickerLock = NSLock()

@_cdecl("dir_picker_pick")
public func dirPickerPick(
    _ nativePort: Int64,
    _ acceptLabelPtr: UnsafePointer<CChar>?,
    _ messagePtr: UnsafePointer<CChar>?
) {
    // acceptLabel and message are macOS-only — ignored on iOS
    let reporter = DirPickerReporter(port: nativePort)

    DispatchQueue.main.async {
        guard let rootVC = getRootViewController() else {
            reporter.sendError(
                code: "PLATFORM_ERROR",
                message: "No root view controller available"
            )
            return
        }

        let helper = DocumentPickerHelper()

        pickerLock.lock()
        activePickerHelper = helper
        pickerLock.unlock()

        helper.pick(from: rootVC) { url in
            pickerLock.lock()
            activePickerHelper = nil
            pickerLock.unlock()

            if let url = url {
                reporter.sendSuccess(uri: url.absoluteString)
            } else {
                reporter.sendCancelled()
            }
        }
    }
}

private func getRootViewController() -> UIViewController? {
    if #available(iOS 15.0, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    } else {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}

#elseif os(macOS)

@_cdecl("dir_picker_pick")
public func dirPickerPick(
    _ nativePort: Int64,
    _ acceptLabelPtr: UnsafePointer<CChar>?,
    _ messagePtr: UnsafePointer<CChar>?
) {
    let reporter = DirPickerReporter(port: nativePort)
    // Copy C strings immediately — safe to free the Dart-side pointers after this call returns
    let acceptLabel = acceptLabelPtr.map { String(cString: $0) } ?? "Select"
    let message = messagePtr.map { String(cString: $0) } ?? "Choose a directory"

    PanelPickerHelper.pick(acceptLabel: acceptLabel, message: message) { url in
        if let url = url {
            reporter.sendSuccess(uri: url.absoluteString)
        } else {
            reporter.sendCancelled()
        }
    }
}
#endif
