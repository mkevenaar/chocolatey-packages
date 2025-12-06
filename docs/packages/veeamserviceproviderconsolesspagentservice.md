# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@2a777a345e0e3086eb4c3acc950f5f57905b1c2f/icons/veeam-service-provider-console-ssp-agent-service.png" width="32" height="32"/> [![Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents](https://img.shields.io/chocolatey/v/veeam-service-provider-console-ssp-agent-service.svg?label=Veeam+Service+Provider+Console+Application+Server+for+Self-Service+Portal+for+Veeam+Agents)](https://community.chocolatey.org/packages/veeam-service-provider-console-ssp-agent-service) [![Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents](https://img.shields.io/chocolatey/dt/veeam-service-provider-console-ssp-agent-service.svg)](https://community.chocolatey.org/packages/veeam-service-provider-console-ssp-agent-service)

## Usage

To install Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-service-provider-console-ssp-agent-service
```

To upgrade Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-service-provider-console-ssp-agent-service
```

To uninstall Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-service-provider-console-ssp-agent-service
```

## Description

Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Service Provider Console Application Server for Self-Service Portal for Veeam Agents

In _Veeam Service Provider Console_, you can restore files and folders to their initial location or download restored data to your computer. When you perform a file-level restore, Veeam Service Provider Console displays the backup content in the **file-level restore portal**. You can browse the guest OS files and folders, restore them to original location and overwrite or keep original objects or download ZIP archive with restored objects to your computer. When you restore guest OS files and folders, Veeam Service Provider Console connects to the Veeam backup agent installed on remote computer which performs the restore process.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-ssp-agent-service/PARAMETERS.md)

#### Required parameters

* `/vacFLRServiceUserName`
* `/vacFLRServicePassword`

* `/vacFLRServiceUserName` - Specifies a user account under which the file-level restore service will run. The account must have local Administrator permissions on the machine where Veeam Service Provider Console server is installed. Example: `/vacFLRServiceUserName:"VAC\flr.admin"`
* `/vacFLRServicePassword` - This parameter must be used if you have specified the `/vacFLRServiceUserName` parameter. Specifies a password for the account under which the file-level restore service will run. Example: `/vacFLRServicePassword:"p@ssw0rd"`

Example: `choco install veeam-service-provider-console-ssp-agent-service --params "/vacFLRServiceUserName:VAC\flr.admin"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-service-provider-console-ssp-agent-service)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-service-provider-console-ssp-agent-service)

