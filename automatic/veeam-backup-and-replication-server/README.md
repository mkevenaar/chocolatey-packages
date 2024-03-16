# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@3b43537c8f99e1ea08563dbe1587c158c4f52e3c/icons/veeam-backup-and-replication-server.png" width="48" height="48"/> [veeam-backup-and-replication-server](https://community.chocolatey.org/packages/veeam-backup-and-replication-server)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Industry-leading backup, recovery and replication software

Veeam® Backup & Replication™ helps businesses achieve comprehensive data protection for ALL workloads — virtual, physical and cloud-based workloads. With a single console, achieve fast, flexible and reliable backup, recovery and replication of all applications and data.

**NOTE** You do have to install a SQL Server before you can use this package.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-backup-and-replication-server/PARAMETERS.md)

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
