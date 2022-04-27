# Veeam ONE Monitor Server package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `ConnectWiseManage` subfolder of the `C:\Program Files\Veeam\Availability Console\Integrations\` folder. Example: `/installDir="C:\Veeam\CWM"` **NOTE:** The component will be installed to the `C:\Veeam\CWM\ConnectWiseManage` folder.
* `/username` - Specifies a user account under which the _ConnectWise Manage Service_ will run. The account must have local Administrator permissions on the machine where _Veeam Service Provider Console_ server is installed. Example: `/username:VAC\cwm.admin`
* `/password` - This parameter must be used if you have specified the `/username` parameter. Specifies a password for the account under which the _ConnectWise Manage Service_ will run. Example: `/password:p@ssw0rd`
* `/create` - Create the requested user on this machine, this user will be added to the local Administrators group.
* `/serverUsername` - Specifies a user account under which the _ConnectWise Manage plugin_ will connect to _Veeam Service Provider Console server_. The account must have local Administrator permissions on the machine where _Veeam Service Provider Console_ server is installed. Example: `/serverUsername:Administrator`
* `/serverPassword` - This parameter must be used if you have specified the `/serverUsername` parameter. Specifies a password for the account under which the _ConnectWise Manage plugin_ will connect to _Veeam Service Provider Console server_. Example: `/serverPassword:p@ssw0rd`
* `/serverName` - Specifies FQDN or IP address of the server where _Veeam Service Provider Console server_ is deployed. Example: `/serverName:vspc.cloudprovider.com`
* `/cwCommunicationPort` - Specifies the port number that _ConnectWise Manage plugin_ uses to communicate with _Veeam Service Provider Console_. This parameter must be used for both _ConnectWise Manage server_ and _ConnectWise Manage UI_ components. If you do not use this parameter, _ConnectWise Manage plugin_ will use the default port 9996. Example: `/cwCommunicationPort:102`

Example: `choco install veeam-service-provider-console-connectwise-manage-service --params "/installdir:C:\Veeam"`
