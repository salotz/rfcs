
# 004: Name Expressions (nexps)

Example:

`namespace.name`

The '.' is used as a namespace separator. Items to the right of it are
said to be "refinements" of the name to the left. There can be
multiple nested namespaces.

The final entry is the 'name' and itself can be broken up into
multiple "fields" separated by underscores '_'. Fields have equal
priority in describing the refinement. Hyphens are used as whitespace
or other symbolic separator within a field name.

This approach was chosen for compatibility with POSIX filenames.
