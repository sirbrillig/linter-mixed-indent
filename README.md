# linter-mixed-indent

An [Atom](https://atom.io/) plugin to mark lines that have differing indentation (spaces vs. tabs).

When a file contains both types of indentation, lines using the less-commonly used indentation will be marked in the editor.

Uses [mixedindentlint](https://github.com/sirbrillig/mixedindentlint) for linting.

![Example](https://cldup.com/5Ap9gFqvCH.png)

# Installation

### atom-linter is required

The [Linter](https://atom.io/packages/linter) package must be installed in order to use this plugin. If it isn't installed, please follow the instructions [here](https://github.com/atom-community/linter#how-to--installation).

### Plugin installation
```sh
$ apm install linter-mixed-indent
```

# Settings

There are options available in the settings panel for the plugin inside Atom's preferences.

### ignore comments

If set, ignore comments entirely in code. Otherwise comment indentation will be scanned as well.

### force indentation type

If not set to automatic, always assume indentation should be one type, rather than scanning the file for the most common indentation.

# Contributing

New issues are welcome! Even better, if you would like to contribute enhancements or fixes, please do the following:

1. Fork the plugin repository
2. Create a new branch from the latest `master`
3. Commit and push the new branch
4. Make a pull request
