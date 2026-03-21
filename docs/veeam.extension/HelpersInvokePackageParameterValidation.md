# Invoke-PackageParameterValidation

<!-- This documentation is automatically generated from https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/veeam.extension/extensions/Invoke-PackageParameterValidation.ps1 using https://github.com/mkevenaar/chocolatey-packages/tree/master/GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

Validates and normalizes Chocolatey package parameters based on simple rule types.

## Syntax


~~~powershell
Invoke-PackageParameterValidation `
  [-Parameters <Hashtable>] `
  [-Rules <Hashtable>] [<CommonParameters>]
~~~

## Description

Checks supplied package parameters against a hashtable of rule names and types.
Ensures required parameters are present, trims values, and normalizes booleans
to '1' or '0'. Throws descriptive errors when a parameter fails validation.


## Aliases

None

## Examples

 **EXAMPLE 1**

~~~powershell

$pp = Get-PackageParameters
$rules = @{
  installDir = 'Path'
  useSsl     = 'Boolean'
  retryCount = 'Integer'
}
Invoke-PackageParameterValidation -Parameters $pp -Rules $rules
~~~ 


## Inputs

None

## Outputs

None

## Parameters


###  -Parameters [&lt;Hashtable&gt;]
Hashtable of parameters, typically the result of Get-PackageParameters. Values
are updated in place when trimmed or normalized.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 1
Default Value          | 
Accept Pipeline Input? | false
 
###  -Rules [&lt;Hashtable&gt;]
Hashtable mapping parameter names to rule types. Supported types:
ZeroOrOne, OneOrTwo, Path, String, Integer, Boolean.

Property               | Value
---------------------- | -----
Aliases                | 
Required?              | false
Position?              | 2
Default Value          | 
Accept Pipeline Input? | false
 
### &lt;CommonParameters&gt;

This cmdlet supports the common parameters: -Verbose, -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, and -OutVariable. For more information, see `about_CommonParameters` http://go.microsoft.com/fwlink/p/?LinkID=113216 .


## Links



[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from `Import-Module "$env:ChocolateyInstalls\veeams\veeam.psm1" -Force; Get-Help Invoke-PackageParameterValidation -Full`.

View the source for [Invoke-PackageParameterValidation](https://github.com/mkevenaar/chocolatey-packages/tree/master//extensions/veeam.extension/extensions/Invoke-PackageParameterValidation.ps1)
