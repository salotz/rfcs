# Git Commit Message Behaviors

Various explanations and meanings of markups used in git commit
messages at a basic level.

## Work In Progress Commits

A "work in progress" (WIP) commit is a commit that is not a completed
incremental change.

WIP commits should start the first line with `wip!` for example:

```
wip! some work to start on new feature

Any other context write here...
```

WIP commits should only be used in branches off of the main branch
and should be rebased away before merging to the main branch.

By having `wip!` in the first line this lets you easily see which
commits need squashed into others in a rebase.

You can also specify a commit as WIP with a git trailer `WIP:
true`. This can be added in addition to the `wip!` prefix and is
recommended.


## Issue References

We generically refer to what are commonly called "issues" in a broader
manner to mean any sort of outside tracking that can be referenced and
addressed by commits. This includes things like issues, tickets,
milestones, MRs etc.

There are many ad hoc or de facto standards for this in various forges
and you should continue to use those as necessary for automations in
those systems. Here we provide a simplified standard for which to
follow in git trailers. If this overlaps with the behavior in those
systems that is fine but if not you should add the standard one
described here that best suits your case.

- Completes: The issue has been directly addressed in the issue and is considered done.
- Progresses: progress has been made towards that issue but not enough to close it.
- References: Simple reference is made with no other attached semantics.

These are used as the git trailer keys for referencing issues.


For the values we also provide a stricter schema that includes
namespacing of the issue system and not relying on something
ambient. For instance the commonly used `#123` for Github issues could
conflict with externally used trackers.


So each value must be prefixed by a namespace, e.g. `#123` for Github
issues would become `github/issues/123` and MR references like `!23`
would become `github/mrs/23`.

The specifics are up to your organization to define but there
minimally should be one namespace and one final ID. Skipping things in
the middle is okay too, for instance `jira/345`.

## Domains

Domains specify which part of the project was affected by the change.

These are similar to the top-level folders of a project.

These are:

- src: the source code
- docs: documentation
- style: formatting of any other domain
- metadata: any metadata files that describe the project, such as
              manifest files.
- build: configuration or scripts for performing builds (not build
           artifacts)
- tests: changes to tests of the project
- deployment: configuration or scripts for deploying the project
- artifacts: if build artifacts are stored with the code this
               implies these were updated. Do not use if artifacts are
               not stored in the same history. (Let the Ops stuff deal
               with that).

Projects can define their own domains as well (perhaps via Code
Ownership), as long as they do not conflict with the above.

