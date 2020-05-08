#import <Foundation/NSObjCRuntime.h>

@class NSString;
extern NSString *const SwiftIOFoundationErrorDomain;
extern NSString *const SwiftIOFoundationExceptionErrorKey;

typedef NS_ERROR_ENUM(SwiftIOFoundationErrorDomain, SwiftIOFoundationErrorCode) {
  SwiftIOFoundationErrorCodeLaunchFailed = 0,
};
