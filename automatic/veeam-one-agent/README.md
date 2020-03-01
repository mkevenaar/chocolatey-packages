# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@9251870dd2e0a833926b39ecc63022625d3b1480/icons/veeam-one-agent.png" width="48" height="48"/> [veeam-one-agent](https://chocolatey.org/packages/veeam-one-agent)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advice you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Monitor

**Veeam ONE Monitor** is used for monitoring the virtual environment and Veeam Backup & Replication infrastructure. In the Veeam ONE Monitor console, you can manage, view and interact with alarms and monitoring data, analyze the performance of virtual and backup infrastructure components, track the efficiency of data protection operations, troubleshoot issues, group your virtual infrastructure and administer monitoring settings.

### Package Parameters

The package accepts the following optional parameters:

* `/server` - Specifies the mode in which Veeam ONE agent will run. If you specify this parameter, the agent will be installed in Server mode. Only required for the Veeam ONE Server
* `/username` - Specifies a user account under which the Veeam ONE Agent service will run. Example: `/username:ONESERVER\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account that will be used to run Veeam ONE Agent. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/agentServicePort` - Specifies a port that will be used by Monitor to communicate with Veeam ONE Agent. By default, port number 2805 is used. Example: `/agentServicePort:2805`

Example: `choco install veeam-one-agent --params "/server /agentServicePort:1234"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
