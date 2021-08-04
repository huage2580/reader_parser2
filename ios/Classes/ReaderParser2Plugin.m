#import "ReaderParser2Plugin.h"
#if __has_include(<reader_parser2/reader_parser2-Swift.h>)
#import <reader_parser2/reader_parser2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "reader_parser2-Swift.h"
#endif

@implementation ReaderParser2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReaderParser2Plugin registerWithRegistrar:registrar];
}
@end
