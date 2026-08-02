You can use an editor for coloring code tags. For instance in emacs
you can use the `hl-todo-mode` package.

Here is some configuration which maps useful colorings to code tags:

```elisp
(global-hl-todo-mode 1)

(setq hl-todo-keyword-faces
      '(
        ("TODO" . "#Ff0000")
        ("FIXME" . "#Ff0000")
        ("TOREV" . "#cc9393")
        ("TODOC" . "#B22222")
        ("REFACT" . "#cc9393")
        ("BUG" . "#cc9393")
        ("REVD" . "#Ff00ff")
        ("WONTFIX" . "#Ff00ff")
        ("CANTFIX" . "#Ff00ff")
        ("DONTFIX" . "#Ff00ff")
        ("DEBUG" . "#A020f0")
        ("QUEST" . "#912cee")
        ("STUB" . "#1e90ff")
        ("SNIPPET" . "#87cefa")
        ("OPT" . "#4169e1")
        ("IDEA" . "#87cefa")
        ("TEST" . "#87cefa")
        ("REQ" . "#87cefa")
        ("CREDIT" . "#556b2f")
        ("NOTE" . "#556b2f")
        ("ALERT" . "#Ff4500")
        ("HACK" . "#Ff4500")
        ("WKRD" . "#Ff4500")
        ("SMELL" . "#Ff4500")
        ("UGLY" . "#Ff4500")
        ("GOTCHA" . "#Ff4500")
        )
      )

```

You can adapt this color scheme to other editors as well.
