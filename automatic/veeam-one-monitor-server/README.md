# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@389832e99573a88fd092dd63dc75280ee55b7ff4/icons/veeam-one-monitor-server.png" width="48" height="48"/> [veeam-one-monitor-server](https://community.chocolatey.org/packages/veeam-one-monitor-server)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Server

**Veeam ONE Server** is responsible for collecting data from virtual servers, vCloud Director servers and Veeam Backup & Replication servers, and storing this data into the database. As part of Veeam ONE Server, the following components should be installed: Veeam ONE Monitor Server and Veeam ONE Reporter Server.

## Manual steps

You'll need an SQL Server (express) installed. It's not required to have this installed on this server. You'll need to specify parameters to connect to the SQL Server.

This package requires you to install the IIS Windows feature and WAS Configuration API feature. You can install these by executing `choco install IIS-WebServer WAS-ConfigurationAPI --source windowsfeatures`

After installing this package, the [Veeam ONE Reporter Server](https://community.chocolatey.org/packages/veeam-one-reporter-server) package must be installed. Package parameters are not passed to depended packages, therefore it's not added as a dependency. You must install this package manually on the same machine for Veeam ONE to work.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-monitor-server/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
