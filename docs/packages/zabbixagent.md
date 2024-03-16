# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@e2236e33581663e56d2b79755c6a126d960681ec/icons/zabbix-agent.png" width="32" height="32"/> [![Zabbix Agent](https://img.shields.io/chocolatey/v/zabbix-agent.svg?label=Zabbix+Agent)](https://community.chocolatey.org/packages/zabbix-agent) [![Zabbix Agent](https://img.shields.io/chocolatey/dt/zabbix-agent.svg)](https://community.chocolatey.org/packages/zabbix-agent)

## Usage

To install Zabbix Agent, run the following command from the command line or from PowerShell:

```powershell
choco install zabbix-agent
```

To upgrade Zabbix Agent, run the following command from the command line or from PowerShell:

```powershell
choco upgrade zabbix-agent
```

To uninstall Zabbix Agent, run the following command from the command line or from PowerShell:

```powershell
choco uninstall zabbix-agent
```

## Description

This package adds the Zabbix agent executables from the [pre-compiled files](https://www.zabbix.com/download_agents) supplied by [Zabbix LLC](https://www.zabbix.com/).

The executables are placed in "%ProgramFiles%\Zabbix Agent" and the zabbix_agentd.conf file is stored in "%ProgramData%\zabbix". After this the service will be installed and set to run.

When new versions of the agent are installed, the original config is not overwritten but rather the version number of the new file is appended to the name. For example, if version 4.0.0 is installed and then upgraded to version 4.2.1 you will find the sample 4.2.1 config files saved as “zabbix_agentd-4.2.1.conf”.

The source code for this Chocolatey package can be found on [GitHub](https://github.com/zabbix/zabbix-agent-chocolatey). Please file any issues you find in the project's [Issue tracker](https://github.com/zabbix/zabbix-agent-chocolatey/issues).

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/zabbix-agent)

[Software Site](https://www.zabbix.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/zabbix-agent)

