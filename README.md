# vscode-binaries

VS Code binaries for OSX and Linux x64

The version of this package will match the version of VS Code releases it contains.

## Releasing

Ensure `version`, `dependencies` and `devDependencies` from package.json match the specific release of VS Code we want to publish.

[microsoft/vscode](https://github.com/microsoft/vscode)

For example, to publish version 1.33.1 ensure our package.json has this version, along with the same dependencies from package.json in
[vscode 1.33.1 package.json](https://github.com/microsoft/vscode/blob/1.33.1/package.json).

Then run `npm run clean` and `npm publish`
