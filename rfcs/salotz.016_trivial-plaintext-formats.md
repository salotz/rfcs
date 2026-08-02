# 016: Nearly Trivial Plaintext Formats

- nexp :: `salotz.016_trivial-plaintext-formats`
- long name :: Nearly Trivial Plaintext Formats
- executive summary :: A small collection of nearly trivial plaintext formats along with file extensions. Includes a line-based list format (.list) and a single-string format (.str).


This spec is more about being able to easily recognize when a file is
truly simple and not actually more complex.


## A "list" file

A file where each line will be parsed as a separate
string. Essentially a newline separated ("\n") list of tokens.

Supports '#' comments.

Has a `.list` extension.

## A "string" file

Sometimes you want a file that has a single string in it that should
just be read directly and not parsed.

Has a `.str` extension.

This is distinct from a `.txt` file in that the TXT file is freeform
and no parsing is intended. The file is intended to be read by a user
as-is.

Furthermore, a TXT file shouldn't contain "data" like an 'str' file
would in the sense of a programming language might.

## A "list" line

A single line with multiple entries. Separated by a separator. By
default uses a `,` comma as the separator,
e.g. `1,2,3,hello`. Alternatively use `:` as a separator when `,` is a
valid character.
