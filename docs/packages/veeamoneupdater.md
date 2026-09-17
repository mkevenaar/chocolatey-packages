# Veeam ONE Updater

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@5d9970cbac34a2a05aad0c9c15b4a5fc7ce2212b/icons/veeam-one-updater.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/veeam-one-updater.svg?label=Veeam+ONE+Updater>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/veeam-one-updater.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/veeam-one-updater>

## Usage

To install Veeam ONE Updater, run the following command:

```powershell
choco install veeam-one-updater
```

To upgrade Veeam ONE Updater, run the following command:

```powershell
choco upgrade veeam-one-updater
```

To uninstall Veeam ONE Updater, run the following command:

```powershell
choco uninstall veeam-one-updater
```

## Description

### Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable
this feature `choco feature enable -n=exitOnRebootDetected`

### About Veeam ONE Updater

**Veeam ONE Updater** is an automated update management service for
Windows-based Veeam environments. This Chocolatey package installs the Veeam
Updater service, which is also bundled with Veeam ONE, and provides automated
management of Veeam product updates.

Veeam Updater helps keep Veeam installations secure and up to date by
automatically installing the latest security updates. Optional updates,
including minor product releases, can also be enabled where appropriate.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-updater)

[Software Site](https://www.veeam.com)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-updater)
