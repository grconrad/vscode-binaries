# vscode-binaries

VS Code binaries for OSX and Linux x64

The version of this package will match the version of VS Code releases it contains.

## Releasing

VS Code source is found at [microsoft/vscode](https://github.com/microsoft/vscode).

In our package.json set `version` to target version of VS Code release. Example: 1.40.2

Find that release's package.json e.g. [vscode 1.40.2 package.json](https://github.com/microsoft/vscode/blob/1.40.2/package.json)
and copy its `dependencies` and `devDependencies` into our own package.json (overwriting whatever we had before).

Then `npm publish` should clean, download and do the necessary packaging.
