# 003: RFC specifications

### Required information

- nexp :: The identifier for the RFC. Names in nexps for RFCs should
  have the following fields: number (0 padded number, short name). 
- long name :: More accurate description in long form. Traditional
  human style title like "My RFC"
- executive summary :: TL;DR explanation maximum 500 words.

### Naming RFC proposals

RFC in the traditional usage is from a particular collection of
organizations.

However, this proposes a more decentralized and open process for
community driven proposals, formats, protocols, and best practices.

Thus we propose using a namespaced identification of RFCS.

RFC names then should be prefixed using the online "handle" of whoever
(or whatever organization) takes ownership of it. More formal methods
of assigning namespaces could be considered, but we propose this
assuming good faith in the community and that handles are fairly well
disambiguated. This will allow many people to contribute with means
under their own control (i.e. source code repo).

For example the RFC listings of my handle `salotz` would look like:
`salotz.XXX_short-name`. Where `XXX` is typically a series of
digits 0-9. We impose no restriction on the number or ordering of
these, however we suggest using a strategy of starting with `001` and
increasing monotonically `002`, `003`, etc. until `999`. Letters are
also allowed, but they must be capitalized. This must be unique within
a namespace. The `short-name` segment is optional, but if
present should attempt to be some string that gives some memorability
or description to the proposal. These should also be unique, but
exceptions can be made.

### Writing RFCs

The rest of the body of the RFC is not specified and you should write
as you see fit.
