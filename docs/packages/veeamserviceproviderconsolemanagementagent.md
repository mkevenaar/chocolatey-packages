# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@6cb7a93ca97ce99f3d17066412302e1a222ee3dd/icons/veeam-service-provider-console-server.png" width="32" height="32"/> [![Veeam Service Provider Console Management Agent](https://img.shields.io/chocolatey/v/veeam-service-provider-console-management-agent.svg?label=Veeam+Service+Provider+Console+Management+Agent)](https://community.chocolatey.org/packages/veeam-service-provider-console-management-agent) [![Veeam Service Provider Console Management Agent](https://img.shields.io/chocolatey/dt/veeam-service-provider-console-management-agent.svg)](https://community.chocolatey.org/packages/veeam-service-provider-console-management-agent)

## Usage

To install Veeam Service Provider Console Management Agent, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-service-provider-console-management-agent
```

To upgrade Veeam Service Provider Console Management Agent, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-service-provider-console-management-agent
```

To uninstall Veeam Service Provider Console Management Agent, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-service-provider-console-management-agent
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Service Provider Console Management Agent

**Veeam Service Provider Console Management Agent** can act as a cloud agent, client agent, master agent or infrastructure agent to interact with _Veeam Service Provider Console_ and managed workloads.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-management-agent/PARAMETERS.md)

#### Required parameters

* None by default. Specify `/vacConnectionAccount` and `/vacConnectionAccountPassword` when `/vacAgentAccountType` is set to `2`.

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `CommunicationAgent` subfolder of the `C:\Program Files\Veeam\Availability Console` folder. Example: `/installDir:"C:\Veeam\"` **NOTE:** The component will be installed to the `C:\Veeam\CommunicationAgent` folder.
* `/vacAgentAccountType` - Specifies the type of account under which management agent service will run. Specify `2` if you want to run management agent under a custom account. If you do not use this parameter, management agent service will run under local System account (default value, `1`). Example: `/vacAgentAccountType:2`
* `/vacConnectionAccount` - Specifies the name of an account under which management agent service will run. You must use this parameter if you have specified `2` for the `/vacAgentAccountType` parameter. Example: `/vacConnectionAccount:"masteragent\backupadmin"`
* `/vacConnectionAccountPassword` - Specifies the password of an account under which management agent service will run. You must use this parameter if you have specified `2` for the `/vacAgentAccountType` parameter. Example: `/vacConnectionAccountPassword:"P@ssw0rd"`
* `/vacManagementAgentTagName` - Specifies the custom tag for the management agent. Example: `/vacManagementAgentTagName:"alfa_company"`

Example: `choco install veeam-service-provider-console-management-agent --params "/installdir:C:\Veeam"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-service-provider-console-management-agent)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-service-provider-console-management-agent)

