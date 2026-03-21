$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_9.0.0.29555.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename
$isoToolsPath = Join-Path (Join-Path $commonPath $isoPackageName) 'tools'
$settingsFile = Join-Path $isoToolsPath 'VeeamPortalSetupSettings.xml'

if (-not (Test-Path -LiteralPath $installPath)) {
  throw "Unable to locate ISO source '$installPath'. Ensure dependency '$isoPackageName' is installed."
}

$fileLocation = 'Plugins\VeeamAgent\FLRPortal\VSPC.VeeamAgentsSelfServicePortalWebUI.x64.msi'

$pp = Get-PackageParameters

if (-not $pp.vacFLRWebAPIHostName -or -not $pp.vacFLRWebAPIUserName -or -not $pp.vacFLRWebAPIPassword) {
  throw "A Required package parameter is missing, please provide the 'vacFLRWebAPIHostName','vacFLRWebAPIUserName','vacFLRWebAPIPassword' parameters"
}

$parameterValidationRules = @{
  vacFLRWebAPIHostName = 'String'
  vacFLRWebAPIPort     = 'Integer'
  vacFLRWebAPIUserName = 'String'
  vacFLRWebAPIPassword = 'String'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules

$silentArgs = New-Object System.Collections.Generic.List[string]

Add-SilentArgument -Buffer $silentArgs -Value ("VAC_FLR_WEBAPI_CONNECTION_HUB_HOST_NAME=`"{0}`"" -f $pp.vacFLRWebAPIHostName)

if ($pp.ContainsKey('vacFLRWebAPIPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_FLR_WEBAPI_CONNECTION_HUB_PORT={0}" -f $pp.vacFLRWebAPIPort)
}

Add-SilentArgument -Buffer $silentArgs -Value ("VAC_FLR_WEBAPI_CONNECTION_HUB_ACCOUNT_NAME=`"{0}`"" -f $pp.vacFLRWebAPIUserName)
Add-SilentArgument -Buffer $silentArgs -Value ("VAC_FLR_WEBAPI_CONNECTION_HUB_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.vacFLRWebAPIPassword)

Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_THIRDPARTY_LICENSES=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_EULA=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_REQUIRED_SOFTWARE=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_LICENSING_POLICY=1'
Add-SilentArgument -Buffer $silentArgs -Value '/qn'
Add-SilentArgument -Buffer $silentArgs -Value '/norestart'
Add-SilentArgument -Buffer $silentArgs -Value "/l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""

$msiSilentArgs = $silentArgs -join ' '

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Self-Service Portal APIs for Veeam Agents*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = $msiSilentArgs
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

$patchArgs = @{
  PackageName    = $env:ChocolateyPackageName
  IsoFile        = $installPath
  SettingsFile   = $settingsFile
  SilentArgs     = $msiSilentArgs
  ValidExitCodes = @(0,1638,1641,3010)
  Destination    = $toolsDir
  ProductName    = 'VeeamAgentsSelfServicePortalWebUi'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
