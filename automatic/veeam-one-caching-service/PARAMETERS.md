# Veeam ONE Caching Service package parameters

## Package Parameters

The package accepts the following parameters:

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
