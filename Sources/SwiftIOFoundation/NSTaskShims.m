#import "NSTaskShims.h"
#import "SwiftIOFoundationError.h"
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSException.h>
#import <Foundation/NSURL.h>
#import <errno.h>

@implementation NSTask (SwiftIOFoundation)

- (NSURL *)swiftio_executableURL {
  if (@available(macOS 10.13, *)) {
    return self.executableURL;
  } else {
    return [NSURL fileURLWithPath:self.launchPath];
  }
}

- (void)swiftio_setExecutableURL:(NSURL *)url {
  if (@available(macOS 10.13, *)) {
    self.executableURL = url;
  } else {
    self.launchPath = url.path;
  }
}

- (BOOL)swiftio_launchAndReturnError:(out NSError *__autoreleasing  _Nullable *)error {
  if (@available(macOS 10.13, *)) {
    return [self launchAndReturnError:error];
  } else {
    @try {
      errno = 0;
      [self launch];
      return YES;
    }
    @catch (NSException *exception) {
      if (![exception.name isEqualToString:NSInvalidArgumentException] || [exception.reason isEqualToString:@"need a dictionary"]) {
        @throw exception;
      }
      if (error != NULL) {
        if (errno != 0) {
          *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:(NSInteger)errno userInfo:nil];
        } else {
          *error = [NSError errorWithDomain:SwiftIOFoundationErrorDomain
                                       code:SwiftIOFoundationErrorCodeLaunchFailed
                                   userInfo:@{SwiftIOFoundationExceptionErrorKey: exception}];
        }
      }
      return NO;
    }
  }
}

@end
