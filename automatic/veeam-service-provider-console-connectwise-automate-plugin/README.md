# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@a47dcd339b6cc91b6308ef844d086298fa40e96e/icons/veeam-service-provider-console-connectwise-automate-plugin.png" width="48" height="48"/> [veeam-service-provider-console-connectwise-automate-plugin](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-automate-plugin)

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
