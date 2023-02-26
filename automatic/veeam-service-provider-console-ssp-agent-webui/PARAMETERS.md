# # Veeam Service Provider Console Self-Service for Veeam Agent WebUI package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/vacFLRWebAPIHostName` - Specifies FQDN or IP address of the server where Veeam Service Provider Console Web UI is deployed. Example: `/vacFLRWebAPIHostName:“vspc.cloudprovider.com"`
* `/vacFLRWebAPIPort` - Specifies the port number that file-level restore plugin uses to communicate with Veeam Service Provider Console.If you do not use this parameter, file-level restore plugin will use the default port _9999_. Example: `/vacFLRWebAPIPort:"105"`
* `/vacFLRWebAPIUserName` - Specifies a user account under which the file-level restore plugin will connect to Veeam Service Provider Console server. The account must have local Administrator permissions on the machine where Veeam Service Provider Console server is installed. Example: `/vacFLRWebAPIUserName:"Administrator"`
* `/vacFLRWebAPIPassword` - Specifies a password for the account under which the file-level restore plugin will connect to Veeam Service Provider Console server. Example: `/vacFLRWebAPIPassword:"p@ssw0rd"`

Example: `choco install veeam-service-provider-console-self-service-portal-agent-webui --params "/vacFLRWebAPIHostName:vspc.mydomain.tld"`
