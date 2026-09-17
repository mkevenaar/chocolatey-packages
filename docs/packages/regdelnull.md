# RegDelNull

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@164655fda1b23c774a0952998f21ca3f422b2f54/icons/regdelnull.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/regdelnull.svg?label=RegDelNull>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/regdelnull.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/regdelnull>

## Usage

To install RegDelNull, run the following command:

```powershell
choco install regdelnull
```

To upgrade RegDelNull, run the following command:

```powershell
choco upgrade regdelnull
```

To uninstall RegDelNull, run the following command:

```powershell
choco uninstall regdelnull
```

## Description

Scan for and delete Registry keys that contain embedded null-characters that are
otherwise undeleteable by standard Registry-editing tools.

Note: deleting Registry keys may cause the applications they are associated with
to fail.

### Command line usage

__regdelnull__ <_path_> [__-s__]

__-s__    Recurse into subkeys.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/regdelnull)

[Software Site](https://learn.microsoft.com/en-us/sysinternals/downloads/regdelnull)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/regdelnull)
