extern void swiftio_init_userInfoProvider(void);

__attribute__((constructor))
void
_swiftio_exit_error_init_userInfoProvider(void)
{
  swiftio_init_userInfoProvider();
}
