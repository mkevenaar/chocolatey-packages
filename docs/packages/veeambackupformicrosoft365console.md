# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@5f87ccdedd262837aaf45bcd766de6dc5291da78/icons/veeam-backup-for-microsoft-365-console.png" width="32" height="32"/> [![Veeam Backup for Microsoft 365 Console](https://img.shields.io/chocolatey/v/veeam-backup-for-microsoft-365-console.svg?label=Veeam+Backup+for+Microsoft+365+Console)](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-365-console) [![Veeam Backup for Microsoft 365 Console](https://img.shields.io/chocolatey/dt/veeam-backup-for-microsoft-365-console.svg)](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-365-console)

## Usage

To install Veeam Backup for Microsoft 365 Console, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-backup-for-microsoft-365-console
```

To upgrade Veeam Backup for Microsoft 365 Console, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-backup-for-microsoft-365-console
```

To uninstall Veeam Backup for Microsoft 365 Console, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-backup-for-microsoft-365-console
```

## Description

Microsoft 365 provides powerful services within Office 365 — but a comprehensive backup of your Office 365 data is not one of them. **Veeam® Backup _for Microsoft 365_** eliminates the risk of losing access and control over your Office 365 data, including Exchange Online, SharePoint Online, OneDrive for Business and Microsoft Teams — so that your data is always protected and accessible.

Veeam Backup _for Microsoft 365_ gives you the power to securely backup Office 365 to any location — on-premises or in cloud object storage — including Amazon S3, Azure Blob, IBM Cloud or S3 compatible providers on premises.

This package installs the following software by default:

* Veeam Backup for Microsoft 365 Console
* Veeam Backup for Microsoft 365 PowerShell

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

## Package Parameters

The package accepts the following optional parameters:

* `/console` - Only install Veeam Backup for Microsoft Office 365 Console
* `/powershell` - Only install Veeam Backup for Microsoft Office 365 PowerShell

**NOTE** These parameters can be combined. e.g. `-params '"/console"'` to only install the Console part.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-backup-for-microsoft-365-console)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-backup-for-microsoft-365-console)

