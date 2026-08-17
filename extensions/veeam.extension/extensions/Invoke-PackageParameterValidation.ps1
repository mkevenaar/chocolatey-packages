function Invoke-PackageParameterValidation {
<#
.SYNOPSIS
  Validates and normalizes Chocolatey package parameters based on simple rule types.

.DESCRIPTION
  Checks supplied package parameters against a hashtable of rule names and types.
  Ensures required and dependent parameters are present, trims values, and
  normalizes booleans to '1' or '0'. Throws descriptive errors when a parameter
  fails validation.

.PARAMETER Parameters
  Hashtable of parameters, typically the result of Get-PackageParameters. Values
  are updated in place when trimmed or normalized.

.PARAMETER Rules
  Hashtable mapping parameter names to rule types. Supported types:
  ZeroOrOne, ZeroOneOrTwo, OneOrTwo, Path, String, Integer, Boolean.

.PARAMETER RequiredParameters
  Names of package parameters that must be supplied with a non-empty value.

.PARAMETER Dependencies
  Dependency rules for conditionally required parameters. Each rule is a
  hashtable with Parameter and Requires keys. An optional Value key limits the
  rule to the specified normalized parameter value.

.EXAMPLE
  >
  $pp = Get-PackageParameters
  $rules = @{
    installDir            = 'Path'
    useSsl                = 'Boolean'
    certificateThumbprint = 'String'
    retryCount            = 'Integer'
  }
  $dependencies = @(
    @{
      Parameter = 'useSsl'
      Value     = '1'
      Requires  = @('certificateThumbprint')
    }
  )
  Invoke-PackageParameterValidation -Parameters $pp -Rules $rules -RequiredParameters @('installDir') -Dependencies $dependencies

.LINK
  https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersInvokePackageParameterValidation.html
#>
  [CmdletBinding(HelpUri='https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersInvokePackageParameterValidation.html')]
  param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Parameters,

    [Parameter(Mandatory=$true)]
    [hashtable]$Rules,

    [string[]]$RequiredParameters = @(),

    [object[]]$Dependencies = @()
  )

  foreach ($rule in $Rules.GetEnumerator()) {
    $name = $rule.Key
    $type = $rule.Value

    if (-not $Parameters.ContainsKey($name)) {
      continue
    }

    $rawValue = $Parameters[$name]
    if ($null -eq $rawValue) {
      throw "Package parameter '$name' must have a value."
    }

    $trimmedValue = ([string]$rawValue).Trim()

    switch ($type.ToLowerInvariant()) {
      'zeroorone' {
        if ($trimmedValue -ne '0' -and $trimmedValue -ne '1') {
          throw "Package parameter '$name' must be either 0 or 1."
        }
      }
      'zerooneortwo' {
        if ($trimmedValue -ne '0' -and $trimmedValue -ne '1' -and $trimmedValue -ne '2') {
          throw "Package parameter '$name' must be 0, 1, or 2."
        }
      }
      'oneortwo' {
        if ($trimmedValue -ne '1' -and $trimmedValue -ne '2') {
          throw "Package parameter '$name' must be either 1 or 2."
        }
      }
      'path' {
        if ([string]::IsNullOrWhiteSpace($trimmedValue)) {
          throw "Package parameter '$name' must contain a valid path."
        }

        try {
          $null = [System.IO.Path]::GetFullPath($trimmedValue)
        }
        catch {
          throw "Package parameter '$name' must contain a valid path."
        }
      }
      'string' {
        if ([string]::IsNullOrWhiteSpace($trimmedValue)) {
          throw "Package parameter '$name' must be a non-empty string."
        }
      }
      'integer' {
        $parsedValue = 0
        if (-not [int]::TryParse($trimmedValue, [ref]$parsedValue)) {
          throw "Package parameter '$name' must be a valid integer."
        }
      }
      'boolean' {
        $booleanValue = $trimmedValue.ToLowerInvariant()
        $truthy = @('true', '1', 'yes')
        $falsy = @('false', '0', 'no')

        if ($truthy -contains $booleanValue) {
          $trimmedValue = '1'
        }
        elseif ($falsy -contains $booleanValue) {
          $trimmedValue = '0'
        }
        else {
          throw "Package parameter '$name' must be a boolean value (true/false)."
        }
      }
      default {
        throw "Unsupported validation type '$type' configured for package parameter '$name'."
      }
    }

    $Parameters[$name] = $trimmedValue
  }

  foreach ($name in $RequiredParameters) {
    if (-not $Parameters.ContainsKey($name) -or [string]::IsNullOrWhiteSpace([string]$Parameters[$name])) {
      throw "Package parameter '$name' is required."
    }
  }

  foreach ($dependency in $Dependencies) {
    if ($dependency -isnot [hashtable] -or -not $dependency.ContainsKey('Parameter') -or -not $dependency.ContainsKey('Requires')) {
      throw "Package parameter dependency rules must define 'Parameter' and 'Requires'."
    }

    $parameterName = [string]$dependency.Parameter
    if (-not $Parameters.ContainsKey($parameterName)) {
      continue
    }

    if ($dependency.ContainsKey('Value') -and [string]$Parameters[$parameterName] -ne [string]$dependency.Value) {
      continue
    }

    $missingParameters = @(
      foreach ($requiredName in @($dependency.Requires)) {
        if (-not $Parameters.ContainsKey([string]$requiredName) -or [string]::IsNullOrWhiteSpace([string]$Parameters[[string]$requiredName])) {
          [string]$requiredName
        }
      }
    )

    if ($missingParameters.Count -gt 0) {
      $condition = "Package parameter '$parameterName'"
      if ($dependency.ContainsKey('Value')) {
        $condition += " with value '$($dependency.Value)'"
      }
      throw "$condition requires package parameter(s): $($missingParameters -join ', ')."
    }
  }
}
