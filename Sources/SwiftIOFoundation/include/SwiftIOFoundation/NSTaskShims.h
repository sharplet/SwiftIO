#import <Foundation/NSTask.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTask (SwiftIOFoundation)

@property (nonatomic, setter=swiftio_setExecutableURL:) NSURL *swiftio_executableURL;

- (BOOL)swiftio_launchAndReturnError:(out NSError **_Nullable)error
NS_SWIFT_NAME(swiftio_run());

@end

NS_ASSUME_NONNULL_END
