# # Veeam Service Provider Console Self-Service for Veeam Agent Service package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/vacFLRServiceUserName` - Specifies a user account under which the file-level restore service will run. The account must have local Administrator permissions on the machine where Veeam Service Provider Console server is installed. Example: `/vacFLRServiceUserName:"VAC\flr.admin"`
* `/vacFLRServicePassword` - This parameter must be used if you have specified the `/vacFLRServiceUserName` parameter. Specifies a password for the account under which the file-level restore service will run. Example: `/vacFLRServicePassword:"p@ssw0rd"`

Example: `choco install veeam-service-provider-console-ssp-agent-service --params "/vacFLRServiceUserName:VAC\flr.admin"`
