
# 017: Bunker: User De-Militarized Zone

- nexp :: `salotz.017_bunker`
- long name :: Bunker: User De-Militarized Zone
- executive summary :: Introduces the concept of a `bunker` directory for user-only data in $HOME (e.g. `.$USER` or `.$USER.d`). Provides a safe space for customization and configuration that will not be touched by other programs.

## Description

A "bunker" is a directory (commonly named `.$USER` or `.$USER.d`) placed
in a user's home directory. Its purpose is to give the user a private,
application-agnostic place to store personal customizations, scripts,
and configuration that should never be touched or overwritten by other
programs.

This provides a "user demilitarized zone" that protects personal data
from being clobbered during upgrades, reinstalls, or by system-wide
tools.

