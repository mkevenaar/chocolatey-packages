# Veeam ONE ISO downloader

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@ce38da592eedce03ebd09ddf46119408f937431b/icons/veeam-one-iso.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/veeam-one-iso.svg?label=Veeam+ONE+ISO+downloader>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/veeam-one-iso.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/veeam-one-iso>

## Usage

To install Veeam ONE ISO downloader, run the following command:

```powershell
choco install veeam-one-iso
```

To upgrade Veeam ONE ISO downloader, run the following command:

```powershell
choco upgrade veeam-one-iso
```

To uninstall Veeam ONE ISO downloader, run the following command:

```powershell
choco uninstall veeam-one-iso
```

## Description

### Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable
this feature `choco feature enable -n=exitOnRebootDetected`

### Veeam ONE

Veeam ONE Monitor comes as a part of the integrated Veeam ONE solution. It is
the primary tool for monitoring Veeam Backup & Replication, VMware vSphere, and
Microsoft Hyper-V environments.

This package is used as a dependency by other Chocolatey packages. To install
any of the tools, please use one of the other packages.

- [Veeam ONE Agent](https://community.chocolatey.org/packages/veeam-one-agent)
- [Veeam ONE Monitor Client](https://community.chocolatey.org/packages/veeam-one-monitor-client)
- [Veeam ONE Monitor Server](https://community.chocolatey.org/packages/veeam-one-monitor-server)
- [Veeam ONE Reporter Server](https://community.chocolatey.org/packages/veeam-one-reporter-server)
- [Veeam ONE Reporter Web](https://community.chocolatey.org/packages/veeam-reporter-web)

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-iso)

[Software Site](https://www.veeam.com)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-iso)
