## Outstanding Issues

Information here should be ignored and is just ideas for operationalizing tags in tooling and increasing specificity and is not standard.

### Referencing Code Tags

There are a few possibilities for indexing and referencing code tags.

#### Unique UUID

The first is that each code tag could be assigned a unique UUID.

This would allow tags to be referenced across history uniquely and
unambiguously.

The main problems here are:

- generating UUIDs in an editor is cumbersome and too high-friction
- this is overkill for many code tags, which will be resolved quickly
- not human memorable

This doesn't seem desirable to apply to all code tags, but could be
useful in resolving recalcitrant and complex issues across many places
in the code for a selected subset of tags. In this case however, the
tag would likely be associated with a particular issue instead of
having it's own standalone number.

An incremental approach sound better here with support for UUIDs if
desired or necessary.

I.e. if you start with:

```python
  # TODO, salotz: do this thing
  a = 8
```


Then it becomes a bigger issue that will take time to resolve:

```python
  # TODO, salotz, #001_BugZeroDay, 8be99f47-958a-44aa-b3ce-18ded085e898:
  # do this thing
  a = 8


  # TODO, salotz, #001_BugZeroDay, 6bf19569-0adc-44af-ac64-c6dc9719f7ea
  # do this other thing
  b = a + 7
```

Using `uuid` on the command line and `uuidgen` in emacs isn't so bad
though just newbs will complain. Also well supported in python.

Could use something cleaner than UUID but would need access to project
database and then you will run into conflicts and such and I would
like to avoid that.



#### Locator Based

This is an implicit kind of indexing. IMO this should be available no
matter what and could be used internally by editor tools and for
auto-generating URLs for people.

This would use a hybrid approach of an address following the form of:

(commit_hash, rel_file_path, line_number_spec)

This admits a unique ordering via topological sort so that within a
commit you can have only:

(commit_hash, tag_idx)

If you wanted.

Of course this is very unstable wrt to commits etc. and so would
likely need to be used in tandem to the UUID + issue assignment
approach.

### Block Delimiting Tags

It might be interesting to support blocks delimiting the beginning and
end of the area of concern of a block if not obvious from the normal
programming language scopes.

There are a few options here.

#### UUIDs

I have previously floated this idea for tools being able to do
substitutions in "live" source code. That is you just make a block
identified by a single UUID.

```bash

  # BEGIN=31df1513-50ad-4aeb-8a4d-e82d29dabfce

  Some code here

  And here some other stuff.

  # END=31df1513-50ad-4aeb-8a4d-e82d29dabfce
```


This allows you to do funky stuff like interleaving them:

```bash

  # BEGIN=31df1513-50ad-4aeb-8a4d-e82d29dabfce

  Some code here

  # BEGIN=f3d3d0b2-5479-4055-9a13-90f7ee46f28b
  And here some other stuff.

  # END=31df1513-50ad-4aeb-8a4d-e82d29dabfce

  And finally some stuff here.

  # END=f3d3d0b2-5479-4055-9a13-90f7ee46f28b
```




although the comments are really ugly and same issues with generating 


#### Hierarchically

```python
  #### TODO: this is in the outer scope

  ### TODO: one more inside

  for i in range(10):

      ## TODO
      for j in range(5):

          print(i,j)

      ##

  ###

  something = func("hello")

  ####
```


IDK..
