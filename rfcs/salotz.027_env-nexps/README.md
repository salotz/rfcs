# Environment Variable Name Expressions

- nexp :: `salotz.027_env-nexps`
- long name :: Environment Variable Name Expressions
- executive summary :: Adapts name expressions (nexps) to UNIX-style environment variable names. Defines screaming-snake-case names with single underscores separating words and double underscores (dunders) separating fields, plus conventions for leading underscores to mark user-configured vs application-internal "hidden" variables. Covers names only, not values, and is designed to coexist with shell variables in the global environment namespace.


This RFC is inspired by "name expressions" (nexp) [RFC
4](../salotz.004_nexps.md) but adapting the particular constraints of
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
NAMESPACE_EXAMPLE
__IMPLEMENTATION_SPECIFIC_HIDDEN
_IGNORED_VARIABLE
PREFIX__FIELD_A__FIELD_B
```

## Anatomy of a name

Parts of a fully decorated multi-field name:

```text

  varname:    __MY_APP_THING__CURRENT_SESSION__SOCKET_PATH_
              ---------------------------------------------
  name:         MY_APP_THING__CURRENT_SESSION__SOCKET_PATH
                ------------------------------------------
  namespace:    MY
                --
  leaf name:       APP_THING__CURRENT_SESSION__SOCKET_PATH
                   ---------------------------------------
  symbols:      MY APP_THING  CURRENT_SESSION  SOCKET_PATH
                -- ---------  ---------------  -----------
  words:        MY APP THING  CURRENT SESSION  SOCKET PATH
                -- --- -----  ------- -------  ------ ----
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
single word and field. `MY_EXAMPLE` is two words but a single **symbol**
and is preferred over e.g. `MYEXAMPLE`.

`PREFIX__FIELD_A__FIELD_B` has 3 fields, `PREFIX`, `FIELD_A`,
`FIELD_B`, where each field is a **symbol**.

Names without multiple fields are not said to have any fields and only
be a single symbol, like `MY_EXAMPLE`.

Field names should be thought of as tuples like: `("PREFIX", "FIELD_A", "FIELD_B")`.

The order of fields is important but does not imply hierarchy or
namespacing necessarily and should be up to the application to
interpret.

For example globbing has a natural hierarchical aspect: `PREFIX__*`,
`PREFIX__FIELD_A__*`, etc.

## Top-level namespaces

Environment variables must coexist in the same global namespace. This
causes many issues including namespace collisions.

To enable some namespacing and coexist with common patterns in the
wild this spec supports a special case for the first word in the first
symbol of a name.

The first word in the symbol is interpreted as a namespace and
separated from the rest of the word. The rest of the name after the
namespace prefix is called the "leaf name".

Leading underscores should be removed before interpreting namespaces.

For single word names there is no namespace or equivalently the empty namespace `''`.

From the above examples their namespaces and symbols:

For example if you have the variables:

| Name | Namespace | Leaf Name |
| `EXAMPLE` | `''` | `EXAMPLE` |
| `NAMESPACE_EXAMPLE` | `NAMESPACE` | `EXAMPLE` |
| `MY_VARIABLE` | `MY` | `VARIABLE` |
| `MY__WITH_SINGLE_FIELD` | `MY` | `WITH_SINGLE_FIELD` |
| `MY_VARIABLE__WITH_FIELDS` | `MY` | `VARIABLE__WITH_FIELDS` |



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

### Underscore only names

All underscore only symbols are restricted by this spec and are not to
be used and reserved for the platform providing environment variable
management (i.e. shells and not applications).

This includes `_`, `__`, and so on.


## Compatibility notes

This specification knowingly does not cover the behavior of a large
number of environment variable naming schemes. Notably on linux system
there are many, many legacy variables that have no namespaces or use
single words.

This RFC makes no specific recommendations of the content of names but
only their form.

It has been designed to work with these poorly conforming names.

Even with namespaces there is no central standardization body that
reserves particular names and prefixes like WWW TLDs (`.com`, `.org`)
and ultimately applications need to defensively use names which are
unlikely to be used by other applications that it knows nothing about.

Regardless, this RFC recommends treating common names as their own
namespaces and to completely avoid them. This is platform specific but
we encourage the collection of reserved names for different systems as
a reference.

In this RFC we collect some lists of these common names and prefixes
to avoid in the [Unix Names](./unix-names.md) document.

Additionally, when possible applications should publish clearly the
namespace they are using. We also encourage the development of a
separate, but derivative standard which provides a machine readable
data schema for declaring and publishing environment variables and
variable patterns for public dispersal.
