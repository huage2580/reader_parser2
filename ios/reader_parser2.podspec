#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint reader_parser2.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'reader_parser2'
  s.version          = '0.0.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386,arm64' }
  s.vendored_libraries = 'Frameworks/libevparser.a'
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/Frameworks/libevparser.a" }
  s.swift_version = '5.0'
end
