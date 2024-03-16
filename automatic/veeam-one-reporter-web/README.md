# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@3c7e8c21ee2dcb440643a882debf29a88f6b6034/icons/veeam-one-reporter-web.png" width="48" height="48"/> [veeam-one-reporter-web](https://community.chocolatey.org/packages/veeam-one-reporter-web)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Web UI

**Veeam ONE Web UI** is a client part for Veeam ONE Reporter. Veeam ONE Web UI communicates with the database, processes and displays data in a web-based interface.

## Manual steps

You'll need an SQL Server (express) installed. It's not required to have this installed on this server. You'll need to specify parameters to connect to the SQL Server.

This package requires you to install the IIS Windows feature, WAS Configuration API feature, some ASP features and Client Certificate Mapping Authentication. You can install these by executing `choco install IIS-WebServerRole IIS-WindowsAuthentication IIS-WebSockets IIS-ASPNET45 IIS-NetFxExtensibility45 WAS-ConfigurationAPI IIS-ManagementConsole IIS-ManagementService IIS-ClientCertificateMappingAuthentication --source WindowsFeatures`

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-reporter-web/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`
* `/oneServer`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
