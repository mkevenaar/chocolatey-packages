# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@a47dcd339b6cc91b6308ef844d086298fa40e96e/icons/veeam-service-provider-console-connectwise-automate-plugin.png" width="32" height="32"/> [![Veeam Service Provider Console ConnectWise Automate Plugin](https://img.shields.io/chocolatey/v/veeam-service-provider-console-connectwise-automate-plugin.svg?label=Veeam+Service+Provider+Console+ConnectWise+Automate+Plugin)](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-automate-plugin) [![Veeam Service Provider Console ConnectWise Automate Plugin](https://img.shields.io/chocolatey/dt/veeam-service-provider-console-connectwise-automate-plugin.svg)](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-automate-plugin)

## Usage

To install Veeam Service Provider Console ConnectWise Automate Plugin, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-service-provider-console-connectwise-automate-plugin
```

To upgrade Veeam Service Provider Console ConnectWise Automate Plugin, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-service-provider-console-connectwise-automate-plugin
```

To uninstall Veeam Service Provider Console ConnectWise Automate Plugin, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-service-provider-console-connectwise-automate-plugin
```

## Description

Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## VSPC Integration with ConnectWise Automate

_Veeam Service Provider Console_ offers integration with _ConnectWise Automate_ to monitor and manage your backup infrastructure in _ConnectWise Automate Control Center_.

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `ConnectWiseUI` subfolder of the `C:\Program Files\Veeam\Availability Console\Integrations\ConnectWiseAutomate\` folder. Example: `/installDir="C:\Veeam\CWA"` **NOTE:** The component will be installed to the `C:\Veeam\CWA\ConnectWiseUI`.

Example: `choco install veeam-service-provider-console-connectwise-automate-plugin --params "/installDir:C:\VAC"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-automate-plugin)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-service-provider-console-connectwise-automate-plugin)

