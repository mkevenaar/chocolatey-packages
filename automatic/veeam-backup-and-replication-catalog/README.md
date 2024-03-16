# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@9f443d73fb61627f7009b4caf5dbf104afc95c5b/icons/veeam-backup-and-replication-catalog.png" width="48" height="48"/> [veeam-backup-and-replication-catalog](https://community.chocolatey.org/packages/veeam-backup-and-replication-catalog)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Backup Catalog

Veeam Backup Catalog is a feature that stands for VM guest OS file indexing. Veeam Backup Catalog comprises Veeam Guest Catalog services that run on the following servers in the backup infrastructure: Veeam backup server and Veeam Backup Enterprise Manager server.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-backup-and-replication-catalog/PARAMETERS.md)

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
