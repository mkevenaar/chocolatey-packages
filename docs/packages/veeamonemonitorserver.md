# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@aa04db8e6809ba3e4dc22d3320103be9ca70d4c4/icons/veeam-one-monitor-server.png" width="32" height="32"/> [![Veeam ONE Monitor Server](https://img.shields.io/chocolatey/v/veeam-one-monitor-server.svg?label=Veeam+ONE+Monitor+Server)](https://community.chocolatey.org/packages/veeam-one-monitor-server) [![Veeam ONE Monitor Server](https://img.shields.io/chocolatey/dt/veeam-one-monitor-server.svg)](https://community.chocolatey.org/packages/veeam-one-monitor-server)

## Usage

To install Veeam ONE Monitor Server, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-one-monitor-server
```

To upgrade Veeam ONE Monitor Server, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-one-monitor-server
```

To uninstall Veeam ONE Monitor Server, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-one-monitor-server
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Server

**Veeam ONE Server** is responsible for collecting data from virtual servers, vCloud Director servers and Veeam Backup & Replication servers, and storing this data into the database. As part of Veeam ONE Server, the following components should be installed: Veeam ONE Monitor Server and Veeam ONE Reporter Server.

## Manual steps

You'll need an SQL Server (express) installed. It's not required to have this installed on this server. You'll need to specify parameters to connect to the SQL Server.

This package requires you to install the IIS Windows feature and WAS Configuration API feature. You can install these by executing `choco install IIS-WebServer WAS-ConfigurationAPI --source windowsfeatures`

After installing this package, the [Veeam ONE Reporter Server](https://chocolatey.org/packages/veeam-one-reporter-server) package must be installed. Package parameters are not passed to depended packages, therefore it's not added as a dependency. You must install this package manually on the same machine for Veeam ONE to work.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-monitor-server/PARAMETERS.md)

* `/perfCache` - Specifies a path to the folder where Performance Cache will be stored. If you do not use this parameter, the performance cache will be stored to the `C:\PerfCache` folder (default). Example: `/perfCache:D:\Veeam\PerfCache`
* `/installationType` - Specifies the mode in which Veeam ONE will collect data from virtual infrastructure and Veeam Backup & Replication servers. Specify `1` to use the **Optimized for Advanced Scalability Deployment** mode. Specify `2` to use **The Backup Data Only** mode. If you do not use this parameter, Veeam ONE will collect data in the **Optimized for Typical Deployment** mode (default value, `0`). For details, see [Choose Data Collection Mode](https://helpcenter.veeam.com/docs/one/deployment/typical_choose_collection_mode.html). Example: `/installationType:2`
* `/vcSelectedType` - Specifies the type of object to add into Veeam ONE configuration. Specify `0` to add **VMware vCenter Server** or **ESXi Host**. Specify `1` to add **Microsoft Hyper-V Host**, **Failover Cluster** or **SCVMM Server**. If you do not use this parameter, Veeam ONE will skip the virtual infrastructure configuration (default value, `2`). Example: `/vcSelectedType:0`
* `/hvType` - This parameter can be used if you have specified 1 for the `/vcSelectedType` parameter. Specifies the role of the virtual infrastructure server. Specify `1` to add **Failover Cluster**. Specify `2` to add standalone **Hyper-V Host**. If you do not use this parameter, Veeam ONE will add **SCVMM Server** (default value, `0`). Example: `/hvType:2`
* `/vcHost` - This parameter must be used if you have specified `0` or `1` for the `/vcSelectedType` parameter. Specifies FQDN or IP address of the virtual infrastructure server you want to connect. Example: `/vcHost:vcenter01.tech.local`
* `/vcPort` - This parameter must be used if you have specified `0` or `1` for the `/vcSelectedType` parameter. Specifies the port number of the virtual infrastructure server you want to connect. Example: `/vcPort:443`
* `/vcHostUser` - This parameter must be used if you have specified `0` or `1` for the `/vcSelectedType` parameter. Specifies a user account to connect to the virtual infrastructure server. Example: `vcHostUser:tech\administrator`
* `/vcHostPass` - This parameter must be used if you have specified `0` or `1` for the `/vcSelectedType` parameter. Specifies a password for the account to connect to the virtual infrastructure server. Example: `/vcHostPass:p@ssw0rd`
* `/backupAddLater` - This parameter can be used if you have specified `0` or `1` for the `/vcSelectedType` parameter. Specifies if you want to postpone adding Veeam Backup & Replication or Veeam Backup Enterprise Manager Server. Specify `1` to add Veeam Backup & Replication or Veeam Backup Enterprise Manager server later. If you do not use this parameter, you must add Veeam Backup & Replication or Veeam Backup Enterprise Manager (default value, `0`). Example: `/backupAddLater:1`
* `/backupAddType` - This parameter can be used if you have specified `0` or `1` for the `/vcSelectedType` parameter and have not specified `/backupAddLater`. Specifies the role of Veeam Backup & Replication server to add. Specify `0` to add **Veeam Backup & Replication** server. Specify `1` to add **Veeam Backup Enterprise Manager**. Example: `/backupAddType:1`
* `/backupAddHost` - This parameter can be used if you have specified `0` or `1` for the `/vcSelectedType` parameter and have not specified `/backupAddLater`. Specifies FQDN or IP address of the **Veeam Backup & Replication** or **Veeam Backup Enterprise Manager** server you want to connect. Example: `/backupAddHost:backup01.tech.local`
* `/backupAddUser` - This parameter can be used if you have specified `0` or `1` for the `/vcSelectedType` parameter and have not specified `/backupAddLater`. Specifies a user account to connect to **Veeam Backup & Replication** or **Veeam Backup Enterprise Manager** server. Example: `/backupAddUser:backup01\administrator`
* `/backupAddPass` - This parameter can be used if you have specified `0` or `1` for the `/vcSelectedType` parameter and have not specified `/backupAddLater`. Specifies a password for the account to connect to **Veeam Backup & Replication** or **Veeam Backup Enterprise Manager** server. Example: `/backupAddPass:p@ssw0rd`
* `/licenseFile` - Specifies a full path to the license file. If this parameter is not specified, Veeam ONE Free Edition will be installed. Example: `/licenseFile:C:\Users\Administrator\Desktop\veeam_one_subscription_100_100.lic`
* `/sqlServer` - Specifies a Microsoft SQL server and instance on which the Veeam ONE database will be deployed. By default, Veeam ONE uses the LOCALHOST\VEEAMSQL2016 server. Example: `/sqlServer:ONESERVER\VEEAMSQL2016_MY`
* `/sqlDatabase` - Specifies a name of the Veeam ONE database, by default, `VeeamOne`. Example: `/sqlDatabase:VeeamOneDB`
* `/sqlAuthentication` - Specifies if you want to use the Microsoft SQL Server authentication mode to connect to the Microsoft SQL Server where the Veeam ONE database is deployed. Specify `1` to use the SQL Server authentication mode. If you do not use this parameter, Veeam ONE will connect to the Microsoft SQL Server in the Microsoft Windows authentication mode (default value, `0`). Together with this parameter, you must specify the following parameters: `/sqlUsername` and `/sqlPassword`. Example: `/sqlAuthentication:1`
* `/sqlUsername` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a LoginID to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlUsername:sa`
* `/sqlPassword` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a password to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlPassword:p@ssw0rd`
* `/username` - Specifies a user account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database in the Microsoft Windows authentication mode. Example: `/username:ONESERVER\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.

Example: `choco install veeam-one-monitor-server --params "/perfCache:D:\Veeam\PerfCache"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-monitor-server)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-monitor-server)

