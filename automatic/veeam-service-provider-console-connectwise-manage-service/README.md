# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@ec5c687d598772fca8a452832cc6e897a0f70827/icons/veeam-service-provider-console-connectwise-manage-service.png" width="48" height="48"/> [veeam-service-provider-console-connectwise-manage-service](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-manage-service)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## VSPC Integration with ConnectWise Manage

_Veeam Service Provider Console_ offers built-in integration with _ConnectWise Manage_ to combine the functionality of both products and consolidate client data in one place.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-connectwise-manage-service/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`
* `/serverUsername`
* `/serverPassword`
* `/serverName`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
