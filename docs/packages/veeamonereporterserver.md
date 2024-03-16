# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@2ee2fcd53cc3763c730d67ed56857053d503baa0/icons/veeam-one-reporter-server.png" width="32" height="32"/> [![Veeam ONE Reporter Server](https://img.shields.io/chocolatey/v/veeam-one-reporter-server.svg?label=Veeam+ONE+Reporter+Server)](https://community.chocolatey.org/packages/veeam-one-reporter-server) [![Veeam ONE Reporter Server](https://img.shields.io/chocolatey/dt/veeam-one-reporter-server.svg)](https://community.chocolatey.org/packages/veeam-one-reporter-server)

## Usage

To install Veeam ONE Reporter Server, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-one-reporter-server
```

To upgrade Veeam ONE Reporter Server, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-one-reporter-server
```

To uninstall Veeam ONE Reporter Server, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-one-reporter-server
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Server

**Veeam ONE Server** is responsible for collecting data from virtual servers, vCloud Director servers and Veeam Backup & Replication servers, and storing this data into the database. As part of Veeam ONE Server, the following components should be installed: Veeam ONE Monitor Server and Veeam ONE Reporter Server.

## Manual steps

You'll need an SQL Server (express) installed. It's not required to have this installed on this server. You'll need to specify parameters to connect to the SQL Server.

This package requires you to install the IIS Windows feature and WAS Configuration API feature. You can install these by executing `choco install IIS-WebServer WAS-ConfigurationAPI --source windowsfeatures`

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts a lot of parameters. Some of them are required the installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-reporter-server/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`

* `/installDir` - Installs the component to the specified location. By default, Veeam ONE uses the **Veeam ONE Reporter Server** subfolder of the `C:\Program Files\Veeam\Veeam ONE folder`. Example: `/installDir:"C:\Veeam\"` The component will be installed to the `C:\Veeam\Veeam ONE Reporter Server` folder.
* `/username` - Specifies a user account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database in the Microsoft Windows authentication mode. Example: `/username:ONESERVER\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/sqlServer` - Specifies a Microsoft SQL server and instance on which the Veeam ONE database will be deployed. By default, Veeam ONE uses the LOCALHOST\VEEAMSQL2016 server. Example: `/sqlServer:ONESERVER\VEEAMSQL2016_MY`
* `/sqlDatabase` - Specifies a name of the Veeam ONE database, by default, `VeeamOne`. Example: `/sqlDatabase:VeeamOneDB`
* `/sqlAuthentication` - Specifies if you want to use the Microsoft SQL Server authentication mode to connect to the Microsoft SQL Server where the Veeam ONE database is deployed. Specify `1` to use the SQL Server authentication mode. If you do not use this parameter, Veeam ONE will connect to the Microsoft SQL Server in the Microsoft Windows authentication mode (default value, `0`). Together with this parameter, you must specify the following parameters: `/sqlUsername` and `/sqlPassword`. Example: `/sqlAuthentication:1`
* `/sqlUsername` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a LoginID to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlUsername:sa`
* `/sqlPassword` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a password to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlPassword:p@ssw0rd`
* `/licenseFile` - Specifies a full path to the license file. If this parameter is not specified, Veeam ONE Free Edition will be installed. Example: `/licenseFile:C:\Users\Administrator\Desktop\veeam_one_subscription_100_100.lic`
* `/reporterServerCommunicationPort` - Specifies the port number used for communication between Veeam ONE Reporting service and Veeam ONE Web Client. If you do not use this parameter, Veeam ONE Reporting service will use the default port **2742**. Example: `/reporterServerCommunicationPort:"2742"`
* `/reporterServerWebApiPort` - Specifies the port number used for communication with Veeam ONE Web API. If you do not use this parameter, Veeam ONE Reporting service will use the default port **2741**. Example: `/reporterServerWebApiPort:"2741"`
* `/reporterServerWebApiCertificateName` - Specifies the certificate to be used by Veeam ONE Web API. The certificate must be installed to the Certificate Store on the machine where you run installation. If this parameter is not specified, a new self-signed certificate will be generated by `openssl.exe`. Example: `/reporterServerWebApiCertificateName:"vone.mydomain.tld"`
* `/installationType` - Specifies the mode in which Veeam ONE will collect data from virtual infrastructure and Veeam Backup & Replication servers. Specify `1` to use the **Optimized for Advanced Scalability Deployment** mode. Specify `2` to use **The Backup Data Only** mode. If you do not use this parameter, Veeam ONE will collect data in the **Optimized for Typical Deployment** mode (default value, `0`). For details, see [Choose Data Collection Mode](https://helpcenter.veeam.com/docs/one/deployment/typical_choose_collection_mode.html). Example: `/installationType:2`

Example: `choco install veeam-one-reporter-server --params "/installationType:2"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-reporter-server)

[Software Site](http://www.veeam.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-reporter-server)

