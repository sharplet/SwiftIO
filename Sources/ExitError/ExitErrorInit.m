extern void swiftio_init_userInfoProvider(void);

static __attribute__((constructor))
void
SwiftIOInitializeExitErrorUserInfoProvider(void)
{
  swiftio_init_userInfoProvider();
}
