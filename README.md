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

For now the following steps need to be done manually *on a Mac* to build and publish a new version:

1. In our package.jon set `version` to target version of VS Code release (example: 1.40.1)
2. Find that release's package.json e.g. [vscode 1.40.1 package.json](https://github.com/microsoft/vscode/blob/1.40.1/package.json), then copy its `dependencies` and `devDependencies` into our own package.json (overwriting whatever we had before)
3. Run `npm publish --access=public` (or use `--dry-run` to see what would be published)

The prepublish script does these things:
  - Downloads the Linux x64 binary (a .tar.gz file) in memory and immediately extracts it using `tar` inside bin/linux-x64 (observed result is a subdirectory named VSCode-linux-x64)
  - Downloads the darwin binary (a .zip) into bin/darwin and immediately extracts it using `unzip` (observed result is a directory named Visual Studio Code.app)

It must be run *on a Mac* because it relies on `unzip` to extract the Mac zip. Extracting the Mac zip using `tar` leads to strange runtime issues in Electron files, as noted in the script.
