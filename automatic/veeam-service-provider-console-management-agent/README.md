# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@6cb7a93ca97ce99f3d17066412302e1a222ee3dd/icons/veeam-service-provider-console-server.png" width="48" height="48"/> [veeam-service-provider-console-management-agent](https://community.chocolatey.org/packages/veeam-service-provider-console-management-agent)

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam Service Provider Console Management Agent

**Veeam Service Provider Console Management Agent** A Veeam Service Provider Console management agent can act as a cloud agent, client agent, master agent or infrastructure agent.

- **Cloud management agent** is used to interact with _Veeam Cloud Connect_ servers in the service provider infrastructure.
- **Client management agent** is used to interact with _Veeam_ products installed on client computers.
- **Master management agent** is used to perform discovery of computers in the client infrastructure, and automate installation and update of _Veeam backup agents_.
- **Infrastructure management agent** is used to interact with _Veeam_ products hosted in the _service provider infrastructure_.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-service-provider-console-management-agent/PARAMETERS.md)

#### Required parameters

- None by default. Specify `/vacConnectionAccount` and `/vacConnectionAccountPassword` when `/vacAgentAccountType` is set to `2`.

<!-- PARAMETERS.md -->
**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
