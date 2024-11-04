#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_native_unity.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_native_unity'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.frameworks = [ 'UnityFramework' ]

  # Flutter.framework does not contain a i386 slice.
#   s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-framework flutter_unity_widget', 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

#   s.dependency 'flutter_unity_widget'

  s.xcconfig = {
     'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/../UnityLibrary" "${PODS_ROOT}/../.symlinks/flutter/ios-release" "${PODS_CONFIGURATION_BUILD_DIR}"',
     'OTHER_LDFLAGS' => '$(inherited) -framework UnityFramework ${PODS_LIBRARIES}'
  }

  s.resources = ['Assets/**/*']
  s.resource_bundle = {
      'FlutterNativeUnityPlugin' => ['Assets/**/*']
  }
end
