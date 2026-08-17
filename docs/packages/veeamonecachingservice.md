# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@0f180c53cde7cc42faef46a72d94a81d96a4d668/icons/veeam-one-caching-service.png" width="32" height="32"/> [![Veeam ONE Caching Service](https://img.shields.io/chocolatey/v/veeam-one-caching-service.svg?label=Veeam+ONE+Caching+Service)](https://community.chocolatey.org/packages/veeam-one-caching-service) [![Veeam ONE Caching Service](https://img.shields.io/chocolatey/dt/veeam-one-caching-service.svg)](https://community.chocolatey.org/packages/veeam-one-caching-service)

## Usage

To install Veeam ONE Caching Service, run the following command from the command line or from PowerShell:

```powershell
choco install veeam-one-caching-service
```

To upgrade Veeam ONE Caching Service, run the following command from the command line or from PowerShell:

```powershell
choco upgrade veeam-one-caching-service
```

To uninstall Veeam ONE Caching Service, run the following command from the command line or from PowerShell:

```powershell
choco uninstall veeam-one-caching-service
```

## Description

## Exit when reboot detected

When installing / upgrading these packages, I would like to advise you to enable this feature `choco feature enable -n=exitOnRebootDetected`

## Veeam ONE Caching Service

**Veeam ONE Caching Service** is a component of Veeam ONE that provides caching functionality used to improve the performance and responsiveness of Veeam ONE monitoring and reporting operations.

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Package Parameters

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

This package accepts several parameters. Some of them are required for installation. For the full list of parameters, please have a look at the [documentation](https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/veeam-one-caching-service/PARAMETERS.md)

#### Required parameters

* `/username`
* `/password`
* `/postgresqlInstallation`

Example: `choco install veeam-one-caching-service --params "/username:ONESERVER\Administrator /password:p@ssw0rd /postgresqlInstallation:0 /postgresqlServer:ONESERVER"`

* `/username` - Specifies the account under which the Veeam ONE Caching Service will run after installation and upgrade. Specify the account in `DOMAIN\username` format. This parameter is required. Example: `/username:ONESERVER\Administrator`
* `/password` - Specifies the password for the account under which the Veeam ONE Caching Service will run. This parameter is required and must be used together with `/username`. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/postgresqlAuthentication` - Specifies the authentication mode used to connect to the PostgreSQL server where the Veeam ONE warehouse database is deployed. Specify `0` for Windows authentication or `1` for PostgreSQL native authentication. When set to `1`, `/postgresqlUsername` and `/postgresqlPassword` are required. Example: `/postgresqlAuthentication:1`
* `/postgresqlServer` - Specifies the PostgreSQL server on which the Veeam ONE warehouse database is deployed. This parameter is required when `/postgresqlInstallation` is set to `0`. If you do not use this parameter, `localhost` is used. Example: `/postgresqlServer:ONESERVER`
* `/postgresqlPort` - Specifies the port used to connect to the PostgreSQL server. If you do not use this parameter, port `5432` is used. Example: `/postgresqlPort:5432`
* `/postgresqlDatabase` - Specifies the name of the Veeam ONE warehouse database. If you do not use this parameter, `VeeamONEWarehouse` is used. Example: `/postgresqlDatabase:VeeamONEWarehouse`
* `/postgresqlUsername` - Specifies the login ID used to connect to the PostgreSQL server. This parameter is required when `/postgresqlAuthentication` is set to `1`. If you do not use this parameter, `postgres` is used. Example: `/postgresqlUsername:postgres`
* `/postgresqlPassword` - Specifies the password used to connect to the PostgreSQL server. This parameter is required when `/postgresqlAuthentication` is set to `1`. Example: `/postgresqlPassword:p@ssw0rd`
* `/postgresqlInstallation` - Specifies whether the bundled PostgreSQL server is a new installation. Specify `1` for a new bundled PostgreSQL installation or `0` when using an existing PostgreSQL server. This parameter is required. Example: `/postgresqlInstallation:0`
* `/reporterServerWebApiPort` - Specifies the port used by the Veeam ONE Caching Service to connect to the Veeam ONE Reporter Web API. If you do not use this parameter, port `2741` is used. Example: `/reporterServerWebApiPort:2741`
* `/cachingServicePort` - Specifies the port used to interact with the Veeam ONE Caching Service. If you do not use this parameter, port `2743` is used. Example: `/cachingServicePort:2743`

Example: `choco install veeam-one-caching-service --params "/username:ONESERVER\Administrator /password:p@ssw0rd /postgresqlInstallation:0 /postgresqlServer:ONESERVER /postgresqlAuthentication:1 /postgresqlUsername:postgres /postgresqlPassword:pgP@ssw0rd"`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/veeam-one-caching-service)

[Software Site](https://www.veeam.com)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/veeam-one-caching-service)

