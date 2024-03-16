# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@2c17d55938a86437948931982a3b91345fbf65ef/icons/veeam-one-monitor-client.png" width="32" height="32"/> [![Veeam ONE Monitor Client](https://img.shields.io/chocolatey/v/veeam-one-monitor-client.svg?label=Veeam+ONE+Monitor+Client)](https://community.chocolatey.org/packages/veeam-one-monitor-client) [![Veeam ONE Monitor Client](https://img.shields.io/chocolatey/dt/veeam-one-monitor-client.svg)](https://community.chocolatey.org/packages/veeam-one-monitor-client)

## Usage

To install Veeam ONE Monitor Client, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-one-monitor-client
```

To upgrade Veeam ONE Monitor Client, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-one-monitor-client
```

To uninstall Veeam ONE Monitor Client, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-one-monitor-client
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Monitor Client

**Veeam ONE Monitor Client** is a client part for Veeam ONE Monitor Server. Veeam ONE Monitor Client communicates with the Veeam ONE Monitor Server installed locally or remotely

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/installDir` - Installs the component to the specified location. By default, Veeam ONE uses the **Veeam ONE Monitor Client** subfolder of the `C:\Program Files\Veeam\Veeam ONE` folder. Example: `/installDir:"C:\Veeam\"` The component will be installed to the `C:\Veeam\Veeam ONE Monitor Client` folder.
* `/monitorServer` - Specifies FQDN or IP address of the server where Veeam ONE Monitor is deployed. Example: `/monitorServer:oneserver.tech.local`

Example: `choco install veeam-one-monitor-client --params "/monitorServer:oneserver.tech.local"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-monitor-client)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-monitor-client)

