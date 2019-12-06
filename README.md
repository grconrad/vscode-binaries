# vscode-binaries

This project exists to bundle VS Code binaries for Mac and Linux x64 in an npm package that can be
scanned and hosted in a non-public artifact repository for use in CI environments where networking
is restricted (specifically for running integration tests of VS Code extensions that require
launching VS Code).

Its version will match the version of VS Code releases it contains for these two platforms.

Note: VS Code source is found at [microsoft/vscode](https://github.com/microsoft/vscode).

Anyone can download platform-specific versions of VS Code at any time from [the public VS Code
download site](https://code.visualstudio.com/download). However, it's common for CI environments to
exist behind a firewall where outbound network access is limited to internal endpoints such as
private artifact repositories.

This project allows VS Code binaries to be brought into such an environment, with relevant
dependencies mentioned as `devDependencies` in package.json so that package scanners can do their
job properly (checking for licenses, security vulnerabilities, etc.) and projects that build VS Code
extensions can get the needed VS Code binary.

## Consuming

Consume this package as a dev dependency (add it to `devDependencies`). When this package is
installed, its postinstall script extracts the appropriate binary based on the client platform.

Point to the binary inside bin/linux-x64 or bin/darwin when using [vscode-test](https://github.com/microsoft/vscode-test)
to run your extension integration tests.

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

(See [VS Code extension testing docs](https://code.visualstudio.com/api/working-with-extensions/testing-extension)
for more context.)

This setup should allow running vscode-test based integration tests of a VS Code extension on either
a Mac or Linux x64 box.

## Building and releasing

To build and publish a new version, do the following:

1. Set version. In package.json set `version` to target version of VS Code release (example: 1.39.2)
2. Clear out dependencies. In package.json clear out `dependencies` and `devDependencies`
3. Specify dependencies as dev dependencies. In vscode repo find the version tag, locate package.json (e.g. [here](https://github.com/microsoft/vscode/blob/1.39.2/package.json)),
and copy all of its `dependencies` and `devDependencies` into our package.json `devDependencies`
(overwrite)
4. Alphabetize. `npx sort-package-json`
5. Download the binaries. `npm build`
6. Publish. `npm publish` (use `--dry-run` to see what would be published)

