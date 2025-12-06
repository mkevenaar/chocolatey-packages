# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@211f1cd456f65af7a08353f4130106896618730e/icons/veeam-service-provider-console-webui.png" width="32" height="32"/> [![Veeam Service Provider Console WebUI](https://img.shields.io/chocolatey/v/veeam-service-provider-console-webui.svg?label=Veeam+Service+Provider+Console+WebUI)](https://community.chocolatey.org/packages/veeam-service-provider-console-webui) [![Veeam Service Provider Console WebUI](https://img.shields.io/chocolatey/dt/veeam-service-provider-console-webui.svg)](https://community.chocolatey.org/packages/veeam-service-provider-console-webui)

## Usage

To install Veeam Service Provider Console WebUI, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-service-provider-console-webui
```

To upgrade Veeam Service Provider Console WebUI, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-service-provider-console-webui
```

To uninstall Veeam Service Provider Console WebUI, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-service-provider-console-webui
```

## Description

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

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `Web UI` subfolder of the `C:\Program Files\Veeam\Availability Console` folder. Example: `/installDir="C:\Veeam\"` **NOTE:** The component will be installed to the `C:\Veeam\Web UI` folder.
* `/username` - Specifies a user account under which the _Veeam Service Provider Console Web UI_ will connect to _Veeam Service Provider Console Server_ in the Microsoft Windows authentication mode. Example: `/username:VAC\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the _Veeam Service Provider Console Web UI_ will connect to _Veeam Service Provider Console Server_. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/serverName` - Specifies FQDN or IP address of the server where _Veeam Service Provider Console server_ is deployed. Example: `/serverName:"vac.cloudprovider.com"`
* `/serverManagementPort` - Specifies the port number that the _Veeam Service Provider Console Web UI_ component uses to communicate with the Server component. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1989`. Example: `/serverManagementPort:102`
* `/restApiPort` - Specifies the port number used to exchange RESTful API requests and responses between _Veeam Service Provider Console Web UI_ component and a client application. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1281`. Example: `/restApiPort:105`
* `/websitePort` - Specifies the port number used to transfer traffic between _Veeam Service Provider Console Web UI_ component and a web browser. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1280`. Example: `/websitePort:106`
* `/configureSchannel` - **INSECURE** Specifies if the **High security mode** option must be used for the _Veeam Service Provider Console Web UI_ installation. The option enforces TLS 1.2 encryption protocol and disables using weak ciphers for all communications with the machine on which _Veeam Service Provider Console Web UI_ component runs. Specify `1` to enable **High security mode**. Specify `0` to proceed with installation without enabling **High security mode**. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the **High security mode** by default. Example: `/configureSchannel:1`

Example: `choco install veeam-service-provider-console-webui --params "/installdir:C:\Veeam"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-service-provider-console-webui)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-service-provider-console-webui)

