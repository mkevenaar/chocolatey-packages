# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@6cb7a93ca97ce99f3d17066412302e1a222ee3dd/icons/veeam-service-provider-console-server.png" width="48" height="48"/> [veeam-service-provider-console-server](https://community.chocolatey.org/packages/veeam-service-provider-console-server)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Service Provider Console Application Server

**Veeam Service Provider Console Server** is the engine responsible for providing centralized management of Veeam backup agents and Veeam Backup & Replication.

## Manual steps

You'll need an SQL Server (express) installed. It's not required to have this installed on this server. You'll need to specify parameters to connect to the SQL Server.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-server/PARAMETERS.md)

#### Required parameters

* `/licenseFile`
* `/username`
* `/password`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
