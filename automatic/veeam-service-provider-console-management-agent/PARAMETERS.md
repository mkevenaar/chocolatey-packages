# Veeam Service Provider Console Management Agent package parameters

## Package Parameters

The package accepts the following optional parameters:

* `/installDir` - Installs the component to the specified location. By default, _Veeam Service Provider Console_ uses the `CommunicationAgent` subfolder of the `C:\Program Files\Veeam\Availability Console` folder. Example: `/installDir:"C:\Veeam\"` **NOTE:** The component will be installed to the `C:\Veeam\CommunicationAgent` folder.
* `/vacAgentAccountType` - Specifies the type of account under which management agent service will run. Specify `2` if you want to run management agent under a custom account. If you do not use this parameter, management agent service will run under local System account (default value, `1`). Example: `/vacAgentAccountType:2`
* `/vacConnectionAccount` - Specifies the name of an account under which management agent service will run. You must use this parameter if you have specified `2` for the `/vacAgentAccountType` parameter. Example: `/vacConnectionAccount:"masteragent\backupadmin"`
* `/vacConnectionAccountPassword` - Specifies the password of an account under which management agent service will run. You must use this parameter if you have specified `2` for the `/vacAgentAccountType` parameter. Example: `/vacConnectionAccountPassword:"P@ssw0rd"`
* `/vacManagementAgentTagName` - Specifies the custom tag for the management agent. Example: `/vacManagementAgentTagName:"alfa_company"`

Example: `choco install veeam-service-provider-console-management-agent --params "/installdir:C:\Veeam"`
