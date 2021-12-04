# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@dadb5921321fb56ca5a60149612bb0fba69daa84/icons/veeam-backup-and-replication-catalog.png" width="48" height="48"/> [veeam-backup-and-replication-catalog](https://community.chocolatey.org/packages/veeam-backup-and-replication-catalog)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Backup Catalog

Veeam Backup Catalog is a feature that stands for VM guest OS file indexing. Veeam Backup Catalog comprises Veeam Guest Catalog services that run on the following servers in the backup infrastructure: Veeam backup server and Veeam Backup Enterprise Manager server.
To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/catalogLocation` - Specifies a path to the catalog folder where index files must be stored. By default, Veeam Backup & Replication creates the VBRCatalog folder on a volume with the maximum amount of free space
* `/username` - Specifies a user account under which the Veeam Guest Catalog Service will run. If you do not specify this parameter, the Veeam Guest Catalog Service will run under the Local System account.
* `/password` - This parameter must be used if you have specified the /username parameter. Specifies a password for the account under which the Veeam Guest Catalog Service will run.
* `/port` - Specifies a TCP port that will be used by the Veeam Guest Catalog Service. By default, port number 9393 is used.
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.

Example: `choco install veeam-backup-and-replication-catalog --params "/port:9000 /catalogLocation:D:\VBRCatalog"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
