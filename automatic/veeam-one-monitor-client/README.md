# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@45e004f54d78b080e7cc6faad718a8c726916db0/icons/veeam-one-monitor-client.png" width="48" height="48"/> [veeam-one-monitor-client](https://chocolatey.org/packages/veeam-one-monitor-client)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advice you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Monitor Client

**Veeam ONE Monitor Client** is a client part for Veeam ONE Monitor Server. Veeam ONE Monitor Client communicates with the Veeam ONE Monitor Server installed locally or remotely

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/monitorServer` - Specifies FQDN or IP address of the server where Veeam ONE Monitor is deployed. Example: `/monitorServer:oneserver.tech.local`

Example: `choco install veeam-one-monitor-client --params "/monitorServer:oneserver.tech.local"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
