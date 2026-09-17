# MySQL (Community Server)

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@f8a062579b8201cc49022144e353496dd6bd03b0/icons/mysql.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/mysql.svg?label=MySQL+(Community+Server)>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/mysql.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/mysql>

## Usage

To install MySQL (Community Server), run the following command:

```powershell
choco install mysql
```

To upgrade MySQL (Community Server), run the following command:

```powershell
choco upgrade mysql
```

To uninstall MySQL (Community Server), run the following command:

```powershell
choco uninstall mysql
```

## Description

MySQL Community Edition is the freely downloadable version of the world's most
popular open source database. It is available under the GPL license and is
supported by a huge and active community of open source developers.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

### Package Parameters

The package accepts the following optional parameters:

- `/installLocation` - filesystem location for mysql binaries
- `/dataLocation` - filesystem location for mysql data
- `/port` - numberic TCP listening port
- `/serviceName` - custom name for the Windows services entry

Example: `choco install mysql --params "/port:3307 /serviceName:AltSQL"`

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/mysql)

[Software Site](http://mysql.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/mysql)
