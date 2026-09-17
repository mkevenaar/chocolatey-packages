# TCPVcon

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@063ff9b74c2db9c04d9fd1fb9a239adbea3c0d71/icons/tcpvcon.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/tcpvcon.svg?label=TCPVcon>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/tcpvcon.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/tcpvcon>

## Usage

To install TCPVcon, run the following command:

```powershell
choco install tcpvcon
```

To upgrade TCPVcon, run the following command:

```powershell
choco upgrade tcpvcon
```

To uninstall TCPVcon, run the following command:

```powershell
choco uninstall tcpvcon
```

## Description

TCPVcon will show you detailed listings of all TCP and UDP endpoints on your
system, including the local and remote addresses and state of TCP connections.
On Windows Server 2008, Vista, and XP, TCPVcon also reports the name of the
process that owns the endpoint. TCPVcon provides a more informative and
conveniently presented subset of the Netstat program that ships with Windows.

### Command line usage

Tcpvcon usage is similar to that of the built-in Windows netstat utility:

__tcpvcon__ [__-a__] [__-c__] [__-n__] [[process name] [PID]]

__-a__  Show all endpoints (default is to show established TCP connections)

__-c__  Print output as CSV

__-n__  Don't resolve addresses

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/tcpvcon)

[Software Site](https://learn.microsoft.com/en-us/sysinternals/downloads/tcpview)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/tcpvcon)
