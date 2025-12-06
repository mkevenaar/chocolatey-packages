# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@ec5c687d598772fca8a452832cc6e897a0f70827/icons/veeam-service-provider-console-connectwise-manage-service.png" width="32" height="32"/> [![Veeam Service Provider Console Application Server for Veeam ConnectWise Manage Plugin](https://img.shields.io/chocolatey/v/veeam-service-provider-console-connectwise-manage-service.svg?label=Veeam+Service+Provider+Console+Application+Server+for+Veeam+ConnectWise+Manage+Plugin)](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-manage-service) [![Veeam Service Provider Console Application Server for Veeam ConnectWise Manage Plugin](https://img.shields.io/chocolatey/dt/veeam-service-provider-console-connectwise-manage-service.svg)](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-manage-service)

## Usage

To install Veeam Service Provider Console Application Server for Veeam ConnectWise Manage Plugin, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-service-provider-console-connectwise-manage-service
```

To upgrade Veeam Service Provider Console Application Server for Veeam ConnectWise Manage Plugin, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-service-provider-console-connectwise-manage-service
```

To uninstall Veeam Service Provider Console Application Server for Veeam ConnectWise Manage Plugin, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-service-provider-console-connectwise-manage-service
```

## Description

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

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `ConnectWiseManage` subfolder of the `C:\Program Files\Veeam\Availability Console\Integrations\` folder. Example: `/installDir="C:\Veeam\CWM"` **NOTE:** The component will be installed to the `C:\Veeam\CWM\ConnectWiseManage` folder.
* `/username` - Specifies a user account under which the _ConnectWise Manage Service_ will run. The account must have local Administrator permissions on the machine where _Veeam Service Provider Console_ server is installed. Example: `/username:VAC\cwm.admin`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the _ConnectWise Manage Service_ will run. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/serverUsername` - Specifies a user account under which the _ConnectWise Manage plugin_ will connect to _Veeam Service Provider Console server_. The account must have local Administrator permissions on the machine where _Veeam Service Provider Console_ server is installed. Example: `/serverUsername:Administrator`
* `/serverPassword` - This parameter must be used if you have specified the `/serverUsername` parameter. Specifies a password for the account under which the _ConnectWise Manage plugin_ will connect to _Veeam Service Provider Console server_. Example: `/serverPassword:p@ssw0rd`
* `/serverName` - Specifies FQDN or IP address of the server where _Veeam Service Provider Console server_ is deployed. Example: `/serverName:vspc.cloudprovider.com`
* `/cwCommunicationPort` - Specifies the port number that _ConnectWise Manage plugin_ uses to communicate with _Veeam Service Provider Console_. This parameter must be used for both _ConnectWise Manage server_ and _ConnectWise Manage UI_ components. If you do not use this parameter, _ConnectWise Manage plugin_ will use the default port 9996. Example: `/cwCommunicationPort:102`
* `/vacServerManagementPort` - Specifies the port number that the ConnectWise Manage Server component uses to communicate with the Veeam Service Provider Console Server component. If you have customized this parameter during Veeam Service Provider Console installation, make sure to specify the customized port number. If you do not use this parameter, ConnectWise Manage Server component will use the default port 1989.Example: `/vacServerManagementPort:102`

Example: `choco install veeam-service-provider-console-connectwise-manage-service --params "/installdir:C:\Veeam"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-service-provider-console-connectwise-manage-service)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-service-provider-console-connectwise-manage-service)

