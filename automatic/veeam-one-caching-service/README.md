# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@0f180c53cde7cc42faef46a72d94a81d96a4d668/icons/veeam-one-caching-service.png" width="48" height="48"/> [veeam-one-caching-service](https://community.chocolatey.org/packages/veeam-one-caching-service)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Caching Service

**Veeam ONE Caching Service** is a component of Veeam ONE that provides caching functionality used to improve the performance and responsiveness of Veeam ONE monitoring and reporting operations.

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts several parameters. Some of them are required for installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-caching-service/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`
* `/postgresqlInstallation`

Example: `choco install veeam-one-caching-service --params "/username:ONESERVER\Administrator /password:p@ssw0rd /postgresqlInstallation:0 /postgresqlServer:ONESERVER"`

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
