force-dedupe-git-modules
========================

Usage
-----

```
$ force-dedupe-git-modules
```

The command forcibly dedupes the modules in node_modules that were obtain from git (i.e. the value-part of the dependency section in package.json is "git+ssh"), by moving all the git-based modules in dependency chain to right below the "./node_modules" directory, preserving the newest version among all of the installed ones.
