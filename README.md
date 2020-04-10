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

## Build

To build a new version there are two options.

**Option 1: Script**

Run the build script with the target VS Code release version number, e.g.

```sh
./scripts/build-new-version.sh 1.44.0
```

This downloads the vscode project's package.json (matching the release version you specified); sets
our package.json to have the same version; takes vscode's devDependencies and dependencies, merges
them, and writes to our devDependencies; sorts our resulting package.json; then downloads the
corresponding VS Code release binaries from the public download site.

**Option 2: Manual process**

1. **Set the version**
   1. Choose the target version (usually the latest released version of VS Code makes sense).
   1. In package.json set `version` to target version of VS Code release (example: 1.44.0)
1. **Set the dependencies** as devDependencies
   1. In package.json remove everything from `dependencies` and `devDependencies`.
   1. In vscode repo find the version tag, locate package.json
(e.g. [here](https://github.com/microsoft/vscode/blob/1.44.0/package.json)), and copy all of its
`dependencies` and `devDependencies` into our package.json `devDependencies` (overwrite).
1. Alphabetize. `npx sort-package-json`
1. Download the binaries. `npm run build`

## Publish

`npm publish` (use `--dry-run` to see what would be published)