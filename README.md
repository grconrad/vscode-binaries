# vscode-binaries

This project exists to package VS Code binaries for Mac and Linux x64.

The version will match the version of VS Code releases it contains for these two platforms.

## Consuming

Point to the binary inside bin/linux-x64 or bin/darwin when using [vscode-test](https://github.com/microsoft/vscode-test).
Example:

```js
    await runTests({
      vscodeExecutablePath: downloadDirToExecutablePath(
        path.resolve(
          extensionDevelopmentPath,
          `node_modules/@grconrad/vscode-binaries/bin/${process.platform === "darwin" ? "darwin" : "linux-x64"}`
        )
      ),
      extensionDevelopmentPath,
      extensionTestsPath
    });
```

This setup should allow running vscode-test based integration tests of a VS Code extension on either a Mac or Linux x64 box.

## Building and releasing

VS Code source is found at [microsoft/vscode](https://github.com/microsoft/vscode).

### Building

To build and publish a new version, do the following:

1. In package.json set `version` to target version of VS Code release (example: 1.39.2)
2. Find that release's package.json (e.g. [here](https://github.com/microsoft/vscode/blob/1.39.2/package.json)), then copy its `dependencies` and `devDependencies` into our package.json (overwriting whatever we had before)
3. Run `npm publish --access=public` (or use `--dry-run` to see what would be published)

The prepublish script downloads binaries for Mac and Linux x64.

When this package is installed, a post-install script extracts the appropriate binary based on the client platform.
