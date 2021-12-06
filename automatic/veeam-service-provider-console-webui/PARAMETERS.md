# Veeam ONE Monitor Server package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `Web UI` subfolder of the `C:\Program Files\Veeam\Availability Console` folder. Example: `/installDir="C:\Veeam\"` **NOTE:** The component will be installed to the `C:\Veeam\Web UI` folder.
* `/username` - Specifies a user account under which the _Veeam Service Provider Console Web UI_ will connect to _Veeam Service Provider Console Server_ in the Microsoft Windows authentication mode. Example: `/username:VAC\Administrator`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the _Veeam Service Provider Console Web UI_ will connect to _Veeam Service Provider Console Server_. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/serverName` - Specifies FQDN or IP address of the server where _Veeam Service Provider Console server_ is deployed. Example: `/serverName:"vac.cloudprovider.com"`
* `/serverManagementPort` - Specifies the port number that the _Veeam Service Provider Console Web UI_ component uses to communicate with the Server component. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1989`. Example: `/serverManagementPort:102`
* `/restApiPort` - Specifies the port number used to exchange RESTful API requests and responses between _Veeam Service Provider Console Web UI_ component and a client application. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1281`. Example: `/restApiPort:105`
* `/websitePort` - Specifies the port number used to transfer traffic between _Veeam Service Provider Console Web UI_ component and a web browser. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the default port `1280`. Example: `/websitePort:106`
* `/configureSchannel` - **INSECURE** Specifies if the **High security mode** option must be used for the _Veeam Service Provider Console Web UI_ installation. The option enforces TLS 1.2 encryption protocol and disables using weak ciphers for all communications with the machine on which _Veeam Service Provider Console Web UI_ component runs. Specify `1` to enable **High security mode**. Specify `0` to proceed with installation without enabling **High security mode**. If you do not use this parameter, _Veeam Service Provider Console Web UI_ component will use the **High security mode** by default. Example: `/configureSchannel:1`

Example: `choco install veeam-service-provider-console-webui --params "/installdir:C:\Veeam"`
