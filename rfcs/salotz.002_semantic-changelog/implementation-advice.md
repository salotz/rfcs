## Parsing Trailers

You can extract these cleanly with:

```bash
git interpret-trailers --parse < commit-message.txt
# or for the last commit:
git log -1 --format=%B | git interpret-trailers --parse
```

This will output only the trailer lines:

```
Change: growth/performance
Domain: src
```

## Optional: Configure Git to recognize trailer keys

Add to your repo's `.git/config` or `~/.gitconfig`:

```ini
[trailer "change"]
    key = Change
    ifexists = add
[trailer "domain"]
    key = Domain
    ifexists = add
[trailer "fixes"]
    key = Fixes
[trailer "progresses"]
    key = Progresses
[trailer "obsoletes"]
    key = Obsoletes
[trailer "wip"]
    key = WIP
```

Then you can do things like:

```bash
git commit --trailer "Change=growth/performance" \
           --trailer "Domain=src"
```
