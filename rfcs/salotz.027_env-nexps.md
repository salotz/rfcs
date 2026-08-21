# Environment Variable Name Expressions

- nexp :: `salotz.027_env-nexps`
- long name :: Environment Variable Name Expressions
- executive summary :: Adapts name expressions (nexps) to UNIX-style environment variable names. Defines screaming-snake-case names with single underscores separating words and double underscores (dunders) separating fields, plus conventions for leading underscores to mark user-configured vs application-internal "hidden" variables. Covers names only, not values, and is designed to coexist with shell variables in the global environment namespace.


This RFC is inspired by "name expressions" (nexp) [RFC
4](./salotz.004_nexps.md) but adapting the particular constraints of
UNIX style environment variables and some other *ad hoc, de facto*
standards common to the community.

This standard is only concerned with environment variable **names**
and not the values they hold.

It is also not concerned with shell variables (e.g. in `bash` or `sh`)
although it is designed to coexist with these as a matter of convention.

Environment variables are assumed to share a singular global namespace.

## Examples

```text
EXAMPLE
MY_VARIABLE
__IMPLEMENTATION_SPECIFIC_HIDDEN
_IGNORED_VARIABLE
PREFIX__FIELD_A__FIELD_B
```

## Words and fields

The typical rule for environment variables is to utilize "screaming snake
case" syntax. Or formally the regex: `^[A-Z_][A-Z0-9_]*$`

All names in this spec must conform to this.

Within this, we specify some meanings to particular usages.

The underscore character `_` and the double-underscore `__` ("dunder"
in brief) are both used as the only separators within alphanumeric words.

Single underscores `_` are used to separate words and dunders `__` are
used to separate "fields".

For instance a common variable name might be `EXAMPLE` which is a
single word and field. `MY_EXAMPLE` is two words but a single field
and is preferred over e.g. `MYEXAMPLE`.

`PREFIX__FIELD_A__FIELD_B` has 3 fields: `PREFIX`, `FIELD_A`, `FIELD_B`.

Field names should be thought of as tuples like: `("PREFIX", "FIELD_A", "FIELD_B")`.

The order of fields is important but does not imply hierarchy or
namespacing necessarily and should be up to the application to
interpret.

For example globbing has a natural hierarchical aspect: `PREFIX__*`,
`PREFIX__FIELD_A__*`, etc.

## Leading and trailing underscores

Leading and trailing underscores have special meanings.

### Leading underscores

Both leading-underscore (glob: `_*`; regex `^_[A-Z_][A-Z0-9_]*$`) and
leading-dunder (glob `__*`; regex `^__[A-Z_][A-Z0-9_]*$`) effectively
signal that a variable is to be "hidden". The meaning of "hidden" is
application specific but typically is interpreted as a variable that
is not to be propagated to sub-process environments.

For instance if in your shell you set `_SHELL_COUNT` or
`__SHELL_COUNT` for some process local purpose and then use a system
that restricts your current environment into another, this hidden
variable should be ignored.

Single leading-underscore names `_*` are intended for users to
configure, e.g. `export _SHELL_COUNT=3`.

Leading dunders `__*` are intended for applications to set variables for
their internal workings. For example an application might set
`__APP_CURRENT_SESSION_SOCKET` and change it during the normal
operation of the application. Operators should never manipulate them
directly.

After leading underscores the rest of the name follows the same rules
for all other names.

For example `__APP_CURRENT_SESSION_SOCKET` strips to the simple name
`APP_CURRENT_SESSION_SOCKET`.

More than two leading underscores are legal but have no reserved or suggested meaning.

### Trailing underscores

Trailing underscores are legal in any number but have no reserved meaning.
