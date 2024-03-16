# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@3b43537c8f99e1ea08563dbe1587c158c4f52e3c/icons/veeam-backup-and-replication-server.png" width="32" height="32"/> [![Veeam Backup & Replication Server](https://img.shields.io/chocolatey/v/veeam-backup-and-replication-server.svg?label=Veeam+Backup+%26+Replication+Server)](https://community.chocolatey.org/packages/veeam-backup-and-replication-server) [![Veeam Backup & Replication Server](https://img.shields.io/chocolatey/dt/veeam-backup-and-replication-server.svg)](https://community.chocolatey.org/packages/veeam-backup-and-replication-server)

## Usage

To install Veeam Backup & Replication Server, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-backup-and-replication-server
```

To upgrade Veeam Backup & Replication Server, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-backup-and-replication-server
```

To uninstall Veeam Backup & Replication Server, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-backup-and-replication-server
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Industry-leading backup, recovery and replication software

Veeam® Backup & Replication™ helps businesses achieve comprehensive data protection for ALL workloads — virtual, physical and cloud-based workloads. With a single console, achieve fast, flexible and reliable backup, recovery and replication of all applications and data.

**NOTE** You do have to install a SQL Server before you can use this package.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-backup-and-replication-server/PARAMETERS.md)

* `/nfsDatastoreLocation` - Specifies the vPower cache folder to which the write cache will be stored. By default, Veeam Backup & Replication uses the folder on a volume with the maximum amount of free space, for example, C:\ProgramData\Veeam\Backup\NfsDatastore\.
* `/backupPort` - Specifies a TCP port that will be used by the Veeam Backup Service. By default, port number 9392 is used.
* `/mountserverPort` - Specifies a port used for communication between the mount server and the backup server. By default, port 9401 is used.
* `/licenseFile` - Specifies a full path to the license file. If you do not specify this parameter, Veeam Backup & Replication will operate in the Community Edition mode.
* `/sqlServer` - Specifies a Microsoft SQL server and instance on which the configuration database will be deployed. By default, Veeam Backup & Replication uses the `(local)\VEEAMSQL2012` server for machines running Microsoft Windows 7, Microsoft Windows Server 2008 or Microsoft Windows Server 2008 R2, and `(local)\VEEAMSQL2016` for machines running Microsoft Windows Server 2012 or later.
* `/sqlDatabase` - Specifies a name for the configuration database. By default, the configuration database is deployed with the `VeeamBackup` name.
* `/sqlAuthentication` - Specifies if you want to use the SQL Server authentication mode to connect to the Microsoft SQL Server where the Veeam Backup & Replication configuration database is deployed. Specify if you want to use the SQL Server authentication mode. If you do not specify this parameter, Veeam Backup & Replication will connect to the Microsoft SQL Server in the Microsoft Windows authentication mode.
* `/sqlUsername` - This parameter must be used if you have specified the /sqlAuthentication parameter. Specifies a LoginID to connect to the Microsoft SQL Server in the SQL Server authentication mode.
* `/sqlPassword` - This parameter must be used if you have specified the /sqlAuthentication parameter. Specifies a password to connect to the Microsoft SQL Server in the SQL Server authentication mode.
* `/username` - Specifies the account under which the Veeam Backup Service will run. The account must have full control NTFS permissions on the VBRCatalog folder where index files are stored and the Database owner rights for the configuration database on the Microsoft SQL Server where the configuration database is deployed. If you do not specify this parameter, the Veeam Backup Service will run under the Local System account.
* `/password` - This parameter must be used if you have specified the /username parameter. Specifies a password for the account under which the Veeam Backup Service will run.
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.

Example: `choco install veeam-backup-and-replication-server --params "/port:9000 /nfsDatastoreLocation:D:\ProgramData\Veeam\Backup\NfsDatastore\"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-backup-and-replication-server)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-backup-and-replication-server)

