#import "ExitError.h"
#import <Foundation/NSError.h>
#import <Foundation/NSString.h>

NSString *const ExitErrorDomain = @"sysexits";

static
NSString * _Nullable
SwiftIOFailureReasonForError(NSError *err)
{
  switch (err.code) {
    case EX_USAGE:
      return @"The command arguments were incorrect.";
    case EX_DATAERR:
      return @"The input data was incorrect.";
    case EX_NOINPUT:
      return @"No such file or directory.";
    case EX_NOUSER:
      return @"No such user.";
    case EX_NOHOST:
      return @"No such host.";
    case EX_UNAVAILABLE:
      return @"The service was unavailable.";
    case EX_SOFTWARE:
      return @"An internal error occurred.";
    case EX_OSERR:
      return @"An internal system error occurred.";
    case EX_OSFILE:
      return @"An error occurred while accessing a system file.";
    case EX_CANTCREAT:
      return @"The output file could not be created.";
    case EX_IOERR:
      return @"An unexpected I/O error occurred.";
    case EX_TEMPFAIL:
      return @"A temporary failure occurred; try again later.";
    case EX_PROTOCOL:
      return @"The remote system returned an incorrect result.";
    case EX_NOPERM:
      return @"Permission denied.";
    case EX_CONFIG:
      return @"A configuration error occurred.";
    default:
      return nil;
  }
}

static __attribute__((constructor))
void
SwiftIOInitializeExitErrorUserInfoProvider(void)
{
  [NSError setUserInfoValueProviderForDomain:ExitErrorDomain provider:^id _Nullable (NSError *err, NSErrorUserInfoKey userInfoKey) {
    if ([userInfoKey isEqualToString:NSLocalizedFailureReasonErrorKey]) {
      return SwiftIOFailureReasonForError(err);
    } else {
      return nil;
    }
  }];
}
