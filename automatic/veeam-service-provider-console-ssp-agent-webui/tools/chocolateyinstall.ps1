$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_8.0.0.18054_20240219.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Plugins\VeeamAgent\FLRPortal\VSPC.VeeamAgentsSelfServicePortalWebUI.x64.msi'

$pp = Get-PackageParameters
if (-not $pp.vacFLRWebAPIHostName -or -not $pp.vacFLRWebAPIUserName -or -not $pp.vacFLRWebAPIPassword) {
  throw "A Required package parameter is missing, please provide the 'vacFLRWebAPIHostName','vacFLRWebAPIUserName','vacFLRWebAPIPassword' parameters"
}

$silentArgs = ""

if ($pp.vacFLRWebAPIHostName) {
  $silentArgs += " VAC_FLR_WEBAPI_CONNECTION_HUB_HOST_NAME=$($pp.vacFLRWebAPIHostName)"
}

if ($pp.vacFLRWebAPIPort) {
  $silentArgs += " VAC_FLR_WEBAPI_CONNECTION_HUB_PORT=$($pp.vacFLRWebAPIPort)"
}

if ($pp.vacFLRWebAPIUserName) {
  $silentArgs += " VAC_FLR_WEBAPI_CONNECTION_HUB_ACCOUNT_NAME=$($pp.vacFLRWebAPIUserName)"
}

if ($pp.vacFLRWebAPIPassword) {
  $silentArgs += " VAC_FLR_WEBAPI_CONNECTION_HUB_ACCOUNT_PASSWORD=$($pp.vacFLRWebAPIPassword)"
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Self-Service Portal APIs for Veeam Agents*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

