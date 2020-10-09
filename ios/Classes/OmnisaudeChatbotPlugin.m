#import "OmnisaudeChatbotPlugin.h"
#if __has_include(<omnisaude_chatbot/omnisaude_chatbot-Swift.h>)
#import <omnisaude_chatbot/omnisaude_chatbot-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "omnisaude_chatbot-Swift.h"
#endif

@implementation OmnisaudeChatbotPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOmnisaudeChatbotPlugin registerWithRegistrar:registrar];
}
@end
