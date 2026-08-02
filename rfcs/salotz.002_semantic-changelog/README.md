# 002: Semantic Changelog

This is an RFC (Request For Comments) stage project for determining a
general purpose format for writing changelog and git commit messages
so that they are human writable, machine readable, and semantically
define what kinds of changes occurred in the patch/commit.

Another name for it is "Growth Versioning".

This RFC then suggests two different artifact formats. First a
structure for writing changelog messages and second a mini-format for
writing git commit messages.

If git commit messages are annotated with change semantics then you
can more easily write the changelog

First we describe the semantics and then the details of the two
artifacts.

See [Implementation Advice](implementation-advice.md) for advice on
how to use these specifications.


## Change Semantics

First we define what semantics we want to actually model about changes.

There are three categories:

- Growth
- Breakage
- Regression

Growth is good and Breakage and Regression are bad.

Breakage is really bad and Regression is less bad.

Within each of these we have more specific sub-categories for
changes. Each keyword implies whether it is growth, breakage, or
regression.

- Growth
  - feature :: a new feature is added
  - relaxed :: a requirement for a component is no longer required
  - repair :: a problem of correctness was fixed; i.e. bugfix
  - performance :: performance was improved
  - clarity :: the ability to understand the system was improved,
               e.g. docstrings, formatting
  - robustness :: a component is better able to deal with failure
                  modes.
- Breakage
  - stricter :: components need more inputs to run
  - stingier :: components return less than they previously did
  - replaced :: a component was replaced with something else under the
                same name
  - rename :: A component is renamed to something else.
  - removal :: A component is removed and the name or component no
               longer exists

- Regression
  - hamstring :: A component has less performance than
       before.
  - deprecation :: A component will still exist (with the same name)
                   but will no longer be supported (usually implies an
                   improved version is somewhere else or is outside of
                   the scope of the project).
  - pollution :: A pollution of namespace. This would be used e.g when
                 you deprecate one name and make a new thing that does
                 almost the same thing elsewhere.
  - noisier :: More output is produced to channels to like stdout and
               stderr. E.g. excess warnings that are mostly
               superfluous. Usually coupled with a growth objective
               and used to avoid making a breakage.

Growth is the improvement of a code base. Users of your code can keep
on using it the way they were before. Or they can use the improved
versions.

For Regression these are things that won't break consumers code
(unless a reduction in performance is breaking) but do make the code
base worse in some respect.

Regressions are preferred to Breakages where possible. Breakages are
when changes in the code will require a change to consumers of that
code.


## Audiences

There are different audiences for various changes. For instance
developers on the project care about refactoring of internal
functions, but not end users.

The audiences are:

- End Users (`users`)
- Contributors (`contributors`)


## Version Numbers

Given that we have strict semantics around changes we choose version
numbers that follow this pattern.

This form of version numbering can be called "Growth Versioning" for
short.

We follow the following format for a version number

```
B.R.G
```

That corresponds to the familiar `MAJOR.MINOR.PATCH` formula but with
different meanings.

Where the `B` number is a version resulting from **ANY** breaking
change.

The number `R` is a version resulting from noteworthy
regressions.

Finally, `G` is the number of versions of noteworthy growth
changes. It starts at 0.

When the breakage version number is incremented this value is reset to
0 (since you effectively have a new software product).

Users should never be afraid to update to the `G` version number
since these are strictly for growth items.

Because, regressions typically don't happen without good reason the
`G` number doesn't reset when it is incremented. This still makes
reasoning about version constraints possible.

Using `R` number is optional.

### Starting a New Project

When starting a new project you should start at `0.0.0` or `0.0`.

At this point there is special meaning for a `B` version number
of 0. Until this is incremented to 1 all breakages should be recorded
as regressions rather than breakages. This communicates the common
pattern of only sticking to a particular interface after "1.0".

# Artifacts

These are recommendations for specific artifacts that leverage the
above semantic recommendations.

## Changelogs

Where applicable we adapt from [Keep A
Changelog](https://keepachangelog.com/en/1.1.0/) directly but change
the names of the fields.

Here is an example:

```markdown

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) with modifications from RFC [002: Semantic Changelog](https://github.com/salotz/rfcs.git)

## [0.2.0] - 2026-08-01

This is a brief description of this change.

### Improvements

### Breakages

### Regressions

```

In each section you don't need to overly specify the subcategories of
changes made.

See the section on [Audiences](#audiences). The audience for the
changelog is the End Users.

See the section on [Version Numbers](#version-numbers) on how version
numbers are decided and formatted.

## Git Commit Messages

See the section on [Audiences](#audiences). The audience for the
changelog is End Users and Contributors.

A commit message should, in addition to the normal good behaviors of
writing commit messages, provide information on change semantics. It
should do this in prose and should also provide structured
metadata. We place no specific recommendations on the formatting of
the prose, except that a human or agent reading it could understand
the semantic impact without reading the code.

The preferred mechanism for structured metadata is using git trailers.

You should not use prefixes like in [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/) to connote
meaning. Except for "Work in Progress" or WIP commits (see [RFC-021:
Git Commit Messages](../salotz.021_git-commit-messages/README.md)).

The accepted keys for trailers are:

| Trailer Key   | Repeatable | Purpose                         | Values                                                                |
|---------------|------------|---------------------------------|-----------------------------------------------------------------------|
| `Change`      | yes        | The kind of semantic change     | `growth`, `breakage`, `regression`                                    |
| `Change-Full` | yes        | The fully qualified change type | See sub-categories for each category. E.g. `growth/feature`. Optional |
| `Audience`    | yes        | Name of the audience.           | `users`, `contributors` |

# Inspirations

This is inspired by Rich Hickey and his discussion on "Semantic
Versioning".
