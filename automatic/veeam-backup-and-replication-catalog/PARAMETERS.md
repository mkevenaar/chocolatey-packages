# Veeam Veeam Backup & Replication Catalog package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/catalogLocation` - Specifies a path to the catalog folder where index files must be stored. By default, Veeam Backup & Replication creates the VBRCatalog folder on a volume with the maximum amount of free space
* `/username` - Specifies a user account under which the Veeam Guest Catalog Service will run. If you do not specify this parameter, the Veeam Guest Catalog Service will run under the Local System account.
* `/password` - This parameter must be used if you have specified the /username parameter. Specifies a password for the account under which the Veeam Guest Catalog Service will run.
* `/port` - Specifies a TCP port that will be used by the Veeam Guest Catalog Service. By default, port number 9393 is used.
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.

Example: `choco install veeam-backup-and-replication-catalog --params "/port:9000 /catalogLocation:D:\VBRCatalog"`
