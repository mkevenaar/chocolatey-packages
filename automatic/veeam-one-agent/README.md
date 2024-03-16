# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@0a1dc3da07e8ad824bdb1ea2fadb450b256ad551/icons/veeam-one-agent.png" width="48" height="48"/> [veeam-one-agent](https://community.chocolatey.org/packages/veeam-one-agent)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Agent

**Veeam ONE Agent** is a component that enables communication with Veeam Backup & Replication servers, performs collection of logs, and sends remediation commands.

Veeam ONE agent can work in the following modes:

* Server:

  In this mode, Veeam ONE agent is responsible for analyzing log data and signature updates.

  Veeam ONE agent server is included into Veeam ONE installation package and deployed on the machine running Veeam ONE Monitor server during product installation.

* Client

  In this mode, Veeam ONE agent is responsible for collecting logs and executing remediation actions on Veeam Backup & Replication servers.By default,

By default, Veeam ONE agent client is deployed on Veeam Backup & Replication servers when you connect these servers to Veeam ONE.

> **IMPORTANT!**
>
> Veeam ONE agent server **must** be installed on the machine that runs Veeam ONE Monitor server.

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

The package accepts the following optional parameters:

* `/installDir`- Installs the component to the specified location. By default, Veeam ONE uses the **Veeam ONE Agent** subfolder of the `C:\Program Files\Veeam\Veeam ONE folder`. Example: `/installDir="C:\Veeam\"` The component will be installed to the `C:\Veeam\Veeam ONE Agent` folder.
* `/server` - Specifies the mode in which Veeam ONE agent will run. If you specify this parameter, the agent will be installed in Server mode. Only required for the Veeam ONE Server
* `/username` - Specifies a user account under which the Veeam ONE Agent service will run. Example: `/username:ONESERVER\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account that will be used to run Veeam ONE Agent. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/agentServicePort` - Specifies a port that will be used by Monitor to communicate with Veeam ONE Agent. By default, port number 2805 is used. Example: `/agentServicePort:2805`

#### Required parameters

* `/username`
* `/password`

Example: `choco install veeam-one-agent --params "/server /agentServicePort:1234"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
