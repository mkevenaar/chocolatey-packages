# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@9f443d73fb61627f7009b4caf5dbf104afc95c5b/icons/veeam-backup-and-replication-catalog.png" width="32" height="32"/> [![Veeam Backup & Replication Catalog](https://img.shields.io/chocolatey/v/veeam-backup-and-replication-catalog.svg?label=Veeam+Backup+%26+Replication+Catalog)](https://community.chocolatey.org/packages/veeam-backup-and-replication-catalog) [![Veeam Backup & Replication Catalog](https://img.shields.io/chocolatey/dt/veeam-backup-and-replication-catalog.svg)](https://community.chocolatey.org/packages/veeam-backup-and-replication-catalog)

## Usage

To install Veeam Backup & Replication Catalog, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-backup-and-replication-catalog
```

To upgrade Veeam Backup & Replication Catalog, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-backup-and-replication-catalog
```

To uninstall Veeam Backup & Replication Catalog, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-backup-and-replication-catalog
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Backup Catalog

Veeam Backup Catalog is a feature that stands for VM guest OS file indexing. Veeam Backup Catalog comprises Veeam Guest Catalog services that run on the following servers in the backup infrastructure: Veeam backup server and Veeam Backup Enterprise Manager server.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-backup-and-replication-catalog/PARAMETERS.md)

* `/catalogLocation` - Specifies a path to the catalog folder where index files must be stored. By default, Veeam Backup & Replication creates the VBRCatalog folder on a volume with the maximum amount of free space
* `/username` - Specifies a user account under which the Veeam Guest Catalog Service will run. If you do not specify this parameter, the Veeam Guest Catalog Service will run under the Local System account.
* `/password` - This parameter must be used if you have specified the /username parameter. Specifies a password for the account under which the Veeam Guest Catalog Service will run.
* `/port` - Specifies a TCP port that will be used by the Veeam Guest Catalog Service. By default, port number 9393 is used.
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.

Example: `choco install veeam-backup-and-replication-catalog --params "/port:9000 /catalogLocation:D:\VBRCatalog"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-backup-and-replication-catalog)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-backup-and-replication-catalog)

