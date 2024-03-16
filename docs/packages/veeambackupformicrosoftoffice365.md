# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@c562e643a55262bbebbf8b0566cb4410fa9e06bc/icons/veeam-backup-for-microsoft-office-365.png" width="32" height="32"/> [![[Deprecated] Veeam Backup for Microsoft Office 365](https://img.shields.io/chocolatey/v/veeam-backup-for-microsoft-office-365.svg?label=%5BDeprecated%5D+Veeam+Backup+for+Microsoft+Office+365)](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-office-365) [![[Deprecated] Veeam Backup for Microsoft Office 365](https://img.shields.io/chocolatey/dt/veeam-backup-for-microsoft-office-365.svg)](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-office-365)

## Usage

To install [Deprecated] Veeam Backup for Microsoft Office 365, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-backup-for-microsoft-office-365
```

To upgrade [Deprecated] Veeam Backup for Microsoft Office 365, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-backup-for-microsoft-office-365
```

To uninstall [Deprecated] Veeam Backup for Microsoft Office 365, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-backup-for-microsoft-office-365
```

## Description

DEPRECATED!

Veeam Backup for Microsoft Office 365 is a comprehensive solution that allows you to back up and restore data of your Microsoft Office 365, on-premises Microsoft Exchange and on-premises Microsoft SharePoint organizations, including Microsoft OneDrive for Business.

This package installs the following software by default:

* Veeam Backup for Microsoft Office 365 Server
* Veeam Backup for Microsoft Office 365 Console
* Veeam Backup for Microsoft Office 365 PowerShell

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/server` - Only install Veeam Backup for Microsoft Office 365 Server
* `/console` - Only install Veeam Backup for Microsoft Office 365 Console
* `/powershell` - Only install Veeam Backup for Microsoft Office 365 PowerShell

**NOTE** These parameters can be combined. e.g. `-params '"/server /powershell"'` to only install Server and PowerShell parts.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-office-365)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/deprecated/veeam-backup-for-microsoft-office-365)

