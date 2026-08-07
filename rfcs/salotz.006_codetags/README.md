
# 006: Codetags

- nexp :: `salotz.006_codetags`
- long name :: Codetags
- executive summary :: Tags that are added in comments to code that add semantic meaning to otherwise freeform comments, making them searchable by machine and available to tooling. Defines a standard set of codetags (TODO, FIXME, etc.) and categories (tasks, warnings, growth, etc.).


This proposal draws on ideas from other projects and proposals most
pre-eminently: [PEP 350](https://www.python.org/dev/peps/pep-0350/)

In this proposal we define a format for codetags as well as a standard
set of code tags along with their meanings and interpretations.

The format is more important than the actual set of tags a team may
adopt. But we provide them as "sane defaults" since these proposals
are meant to be useful on their own.

## Code Tags

Code tags are considered a short all capital letters only (no numbers or symbols) words.

Code tags should only appear and be interpreted as such specifically in comment sections of source code.

Not all comments should have code tags. Comments that directly describe the functioning of a piece of code should generally be considered as purely informational.

Code tags make intentions other than purely informational about the code at the comment section.

Specific commenting conventions of languages differ so we don't specify them here, but some general patterns should be obeyed.

### Format

Code tags take the form of a comment on a line preceding an area of
concern. For example in `python` comments are lines started with a `#`
symbol. The simplest example would be:

```python
  # TODO: remove hard-coding of number of iterations
  for i in range(10):
      print(i)
```

This codetag with comment fits on a single line and refers to a
section of code below it which should be evident from the context of
the code tag comment.

Most code-tags are context dependent and thus should have a comment to
explain that context. For example, `TODO` tags should explain what
there is to do. Others may not that don't need extra context or will
only live for a short time in between commits, e.g. the `DEBUG` tag
which is simply meant to mark something for removal after debugging.

So this would be an "invalid" code tag for obvious reasons:

```python
  # TODO
  for i in range(10):
      print(i)
```


---

If you have separate issues with the same "region" of code use
separate code tags rather than conjunctions in prose. I.e. prefer:

```python
  # TODO: remove hard-coding of number of iterations
  # TODO: rename 'i' variable to something meaningful
  for i in range(10):
      print(i)
```


Over:

```python
  # TODO: remove hard-coding of number of iterations and rename 'i'
  # variable to something meaningful
  for i in range(10):
      print(i)
```


---

Multiline code tags are okay. While we recommend breaking lines into
fixed width, we'll let you and the team argue over that.

If your language supports multiline comments use those, one comment
per tag.

If your language does not start the first line of the "block" with the
code tag and every line after that beginning with a line comment
character up until a white space line or a commented line beginning
with a code tag will be interpreted as a block.

```python
  # TODO: remove hard-coding of number of iterations, this is good
  # practice and you need to do it, tisk tisk
  # TODO: rename 'i' variable to something meaningful, you can escape
  for i in range(10):
      print(i)
```

and so is this:

```python
  # TODO: remove hard-coding of number of iterations, this is good
  # practice and you need to do it, tisk tisk

  # TODO: rename 'i' variable to something meaningful, you can escape
  # of the line break
  for i in range(10):
      print(i)
```


You can also add paragraphs within a single block by just prefixing
with a line comment:

```python
  # TODO: rename 'i' variable to something meaningful.
  #
  # You can escape TODO like this. Which is only useful if it falls at
  # the beginning of the line break
  for i in range(10):
      print(i)
```

You can add multiple tags to a comment:

```python
# TODO,GOTCHA: You need to copy objects before passing to this function
def mutate(thing):
    thing.a = 3
    return thing
```

#### Parametrization

Code tags can be parametrized (tagged) as well:

```bash
  # TODO(paramA, paramB, keyC=paramC): here is the comment
  a = 8
```

Where the parameters follow python semantics, except that all of them
must be keyword arguments. The first few can still have the
positionality inferred though, like as in a function definition like:

```python

  def TODO(keyA, keyB, *, keyC=None):
      pass
```

This is usually only used to denote the user that entered the code tag, however this is usually not necessary as this can be found in your VCS's information.

## Categories:

- tasks: things that have been scheduled for attention
- warnings: things that degrade the quality of the code but have not
  been scheduled for attention
- resolved: things that document resolutions in the code
- temporary: things that are for temporary usage
- growth: things that signify opportunities for growth in the code,
  but which do not degrade the quality of the code currently
- statements: neutral statements about the code
- review: iterative review of regions of code

The presence of tags from each category have implications for what can
get put into production or master branches, we call this "production".

### Tasks

Tasks should ideally never be put into production and should always
have an associated issue in an issue tracker (i.e. scheduled).

Task tags:

- TODO :: A specific item (and location) for a change to be made
- FIXME :: References a specific piece of code that is broken and is
  in need of fixing.
- TOREV :: flags a portion of code for review
- TODOC :: indicates that a portion of code is undocumented
- REFACT :: A refactoring of code is necessary and scheduled, but
  otherwise not broken

### Warnings

Distinct from tasks but still indicating negativity, warnings can be
put into production and typically don't have an issue associated with
them (although they can). This is for quick tagging of sections of
code when it is not critical that they are fixed, but that you would
like to show up in a review.

Warning tags:

- ALERT :: indication that some edge-cases might not be handled but
  they have not yet been formally enumerated or tested for
- HACK :: a piece of code was not structured according to best design
  practices, but is still useful for its utility. Indicates desire for
  a rewrite.
- WKRD :: "workaround"; Code is overly complex due to specific
  workarounds that are necessary. Ideally, should be cleaned up with
  refactoring.
- SMELL :: Code smells, indicating that the author suspects a problem
  with a piece of code but not quite sure if it is a problem.
- UGLY :: Code is not properly formatted or following style guide, or
  is otherwise bas taste.
- GOTCHA :: interfacing with a particular piece of code may be
  difficult or unintuitive.

### Resolved


Resolved tags, for the most part shouldn't actually be in the code,
and typically result in a resolution of an issue in the tracker and
thus a cleaning up of the code to remove tags or replace them with
neutral statements about the code. Resolved tags are for when issues
are resolved, but in an idealistically unsatisfactory way that either
goes against standards generally adhered to by the codebase, good
taste, or may be targetted by future reviewers for changes. The idea
here is to reduce the chance of old unsolvable issue being re-raised
after they were forgotten about.

Resolved tags:

- REVD :: "reviewed"; piece of code has been reviewed. Should be signed.
- WONTFIX :: Fixing code is out of scope for the projects goals as
  determined by author. Usually means that if someone else fixes it
  and makes it frictionless to integrate and fully tested it can be
  changed though.
- CANTFIX :: Code that can't be fixed due to limitations in either the
  requirements, language, or tools itself.
- DONTFIX :: Indicates that a piece of code is extremely delicate in
  it's organization and is highly unintuitive to fix, but nonetheless
  is in a "stable" state.


### Temporary

Temporary tags are used by someone writing code when they need to
resolve certain small things before they check it in. For example
putting in debugging checkpoints or logging and print statements.

Temporary tags:

- DEBUG :: To indicate that there are debugging code that should be
  removed.
- QUEST :: "question"; for marking up code when trying to understand a
  code base.

### Growth

Growth tags are for an author or reviewer to place in observations on
how specific pieces of code could be improved in the future, but are
not necessary now. These don't include real issues like potential bugs
etc. This means things like optimization opportunities.

Growth tags:

- STUB :: a piece of code put in to satisfy an interface but without
  an implementation yet.
- SNIPPET :: Used to show how a setting or functionality would be
  implemented, but currently isn't needed. Saves the reader from
  having to dig through documentation in the future, or if the
  solution is a little clever.
- OPT :: An opportunity for optimization is present that isn't obvious.
- IDEA :: Ideas for improving the code. Not neutral like NOTE.
- TEST :: A sketch of, pseudocode, or code to specify a test of a
  piece of code that hasn't been formally introduced to the test suite
- REQ :: A statement or specification requirement of the code's
  behavior that hasn't been reified to a requirements system in the
  code (like proofs, formatl models etc.)

### Statements

Neutral statements about a piece of code.

Statement Tags:

- CREDIT :: to give credit to somebody for the code itself, the idea, or
  even finding the bugfix or feature idea.
- NOTE :: A neutral statement about code. Without a tag this is
  assumed (by tooling).

### Review


Providing commentary and discussion on a region. For instance might take this flow:

Request for review:

```python
  # TOREV(req="salotz"): not sure this is the right way to do things
  from numpy import *
```

Then the requested reviewer comments:

```python
  # TOREV(asker="newb", req="salotz"): not sure this is the right way to do things

  # REV("salotz", req="newb"): no it's not, should either specifically
  # import things or create a namespace that is more convenient

  from numpy import array

  # REV, SNIPPET: or
  # import numpy as np
```


Asker resolves things:

```python
  # REVD(newb)
  import numpy as np
```

Reviewer can sign off:

```python
  # REVD(newb, salotz)
  import numpy as np
```

Should be committed and then can be removed.

```python
  import numpy as np
```
