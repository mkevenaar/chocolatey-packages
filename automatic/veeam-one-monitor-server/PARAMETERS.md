# Veeam ONE Monitor Server package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/username` - Specifies a user account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database in the Microsoft Windows authentication mode. Example: `/username:ONESERVER\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the Veeam ONE Services will run and that will be used to access Veeam ONE database. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/sqlServer` - Specifies a Microsoft SQL server and instance on which the Veeam ONE database will be deployed. By default, Veeam ONE uses the LOCALHOST\VEEAMSQL2016 server. Example: `/sqlServer:ONESERVER\VEEAMSQL2016_MY`
* `/sqlDatabase` - Specifies a name of the Veeam ONE database, by default, `VeeamOne`. Example: `/sqlDatabase:VeeamOneDB`
* `/sqlAuthentication` - Specifies if you want to use the Microsoft SQL Server authentication mode to connect to the Microsoft SQL Server where the Veeam ONE database is deployed. Specify `1` to use the SQL Server authentication mode. If you do not use this parameter, Veeam ONE will connect to the Microsoft SQL Server in the Microsoft Windows authentication mode (default value, `0`). Together with this parameter, you must specify the following parameters: `/sqlUsername` and `/sqlPassword`. Example: `/sqlAuthentication:1`
* `/sqlUsername` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a LoginID to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlUsername:sa`
* `/sqlPassword` - This parameter must be used if you have specified the `/sqlAuthentication` parameter. Specifies a password to connect to the Microsoft SQL Server in the SQL Server authentication mode. Example: `/sqlPassword:p@ssw0rd`
* `/licenseFile` - Specifies a full path to the license file. If this parameter is not specified, Veeam ONE Free Edition will be installed. Example: `/licenseFile:C:\Users\Administrator\Desktop\veeam_one_subscription_100_100.lic`
* `/installDir` - Installs the component to the specified location. By default, Veeam ONE uses the **Veeam ONE Monitor Server** subfolder of the `C:\Program Files\Veeam\Veeam ONE folder`. Example: `/installDir:"C:\Veeam\"` The component will be installed to the `C:\Veeam\Veeam ONE Monitor Server` folder.
* `/grpcServerPort` - Specifies the port number used for communication between Veeam ONE Monitoring service and Veeam ONE Web Client. If you do not use this parameter, Veeam ONE Monotoring service will use the default port 2714. Example: `/grpcServerPort:"2714"`
* `/perfCache` - Specifies a path to the folder where Performance Cache will be stored. If you do not use this parameter, the performance cache will be stored to the `C:\PerfCache` folder (default). Example: `/perfCache:D:\Veeam\PerfCache`
* `/installationType` - Specifies the mode in which Veeam ONE will collect data from virtual infrastructure and Veeam Backup & Replication servers. Specify `1` to use the **Optimized for Advanced Scalability Deployment** mode. Specify `2` to use **The Backup Data Only** mode. If you do not use this parameter, Veeam ONE will collect data in the **Optimized for Typical Deployment** mode (default value, `0`). For details, see [Choose Data Collection Mode](https://helpcenter.veeam.com/docs/one/deployment/typical_choose_collection_mode.html). Example: `/installationType:2`
* `/autoUpdate` - Specifies if you want to enable automatic updates after Veeam ONE installation. Specify 1 to enable automatic updates. Example: `/autoUpdate:"1"`

Example: `choco install veeam-one-monitor-server --params "/perfCache:D:\Veeam\PerfCache"`
