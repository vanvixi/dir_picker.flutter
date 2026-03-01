#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint dir_picker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'dir_picker'
  s.version          = '0.0.1'
  s.summary          = 'Directory Picker via FFI for iOS and macOS'
  s.description      = <<-DESC
A Flutter plugin for picking directories on iOS and macOS using FFI and DartApiDl NativePort.
                       DESC
  s.homepage         = 'https://github.com/vanvixi/dir_picker.flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vanvixi' => 'vanvixi.dev@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,c,swift}'
  # No public_header_files — C headers are used internally by Swift only
  # (imported via SWIFT_INCLUDE_PATHS + module.modulemap as 'DartApiDl').
  # Exposing them causes CocoaPods to generate an umbrella header that
  # Clang cannot modularize, breaking '@import dir_picker'.

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  s.preserve_paths = 'Classes/include/module.modulemap'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/Classes/include',
    'OTHER_CFLAGS' => '-I$(PODS_TARGET_SRCROOT)/Classes/include'
  }
  s.swift_version = '5.0'
end
