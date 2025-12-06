# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@211f1cd456f65af7a08353f4130106896618730e/icons/veeam-service-provider-console-webui.png" width="48" height="48"/> [veeam-service-provider-console-webui](https://community.chocolatey.org/packages/veeam-service-provider-console-webui)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Service Provider Console Web UI

**Veeam Service Provider Console Web UI** provides a web interface that allows users to interact with Veeam Service Provider Console Server.

## Manual steps

This package requires you to install the IIS Windows feature. You can install these by executing `choco install IIS-WebServer IIS-NetFxExtensibility45 IIS-ASPNET45 --source windowsfeatures`

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-webui/PARAMETERS.md)

#### Required parameters

* `/serverName`
* `/username`
* `/password`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
