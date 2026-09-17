# Veeam Agent for Microsoft Windows

<img
  src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@1aa81f0b9fe0360a5736ecb9fa164bb3eb68cc35/icons/veeam-agent.png"
  alt="Package icon"
  width="32" height="32"/>

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: <https://img.shields.io/chocolatey/v/veeam-agent.svg?label=Veeam+Agent+for+Microsoft+Windows>
[choco-docs-downloads]: <https://img.shields.io/chocolatey/dt/veeam-agent.svg>
[choco-docs-package]: <https://community.chocolatey.org/packages/veeam-agent>

## Usage

To install Veeam Agent for Microsoft Windows, run the following command:

```powershell
choco install veeam-agent
```

To upgrade Veeam Agent for Microsoft Windows, run the following command:

```powershell
choco upgrade veeam-agent
```

To uninstall Veeam Agent for Microsoft Windows, run the following command:

```powershell
choco uninstall veeam-agent
```

## Description

Veeam® Agent for Microsoft Windows provides a simple solution for backing up
Windows-based servers, desktops and laptops. With Veeam Agent for Microsoft
Windows, you can easily back up your computer to an external hard drive, NAS
(network-attached storage) share or a Veeam Backup and Replication™ repository.
And, should ransomware encrypt your files, your system fails to boot, your hard
drive crashes or an important file gets corrupted or accidentally deleted, you
can recover what you need in minutes — like it never happened.

### Package Parameters

- `/NoAutostartHard` - Disables Veeam Agent Gui when starting Windows.
- `/CleanStartmenu` - Removes frequently used Veeam shortcuts from the
  Startmenu.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know
[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)
that the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-agent)

[Software Site](https://www.veeam.com/windows-cloud-server-backup-agent.html)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-agent)
