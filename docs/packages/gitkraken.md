# GitKraken

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@e79a1cb3d5eeda949226195b6119fe41a511b9ce/icons/gitkraken.jpg"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/gitkraken.svg?label=GitKraken>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/gitkraken.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/gitkraken>

## Usage

To install GitKraken, run the following command:

```powershell
choco install gitkraken
```

To upgrade GitKraken, run the following command:

```powershell
choco upgrade gitkraken
```

To uninstall GitKraken, run the following command:

```powershell
choco uninstall gitkraken
```

## Description

GitKraken is a graphical Git client for working with repositories, branches,
commits, merges, and pull requests from a desktop UI.

### Package Notes

GitKraken also has its own in-app update mechanism. This package checks
`%LOCALAPPDATA%\gitkraken\gitkraken.exe` and only reinstalls when the Chocolatey
package version is newer, unless `choco upgrade gitkraken --force` is used.

### Useful Links

- Release notes: <https://www.gitkraken.com/release-notes>
- Documentation:
  <https://help.gitkraken.com/gitkraken-client/gitkraken-client-home/>
- Support: <https://help.gitkraken.com/gitkraken-client/contact-support/>

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/gitkraken)

[Software Site](http://www.gitkraken.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/gitkraken)
