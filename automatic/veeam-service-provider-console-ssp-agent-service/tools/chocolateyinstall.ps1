$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_8.0.0.19236_20240426.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Plugins\VeeamAgent\FLRPortal\VSPC.VeeamAgentsSelfServicePortal.x64.msi'

$pp = Get-PackageParameters
if (-not $pp.vacFLRServiceUserName -or -not $pp.vacFLRServicePassword) {
  throw "A Required package parameter is missing, please provide the 'vacFLRServiceUserName','vacFLRServicePassword' parameters"
}

$silentArgs = ""

if ($pp.vacFLRServiceUserName) {
  $silentArgs += " VAC_FLR_SERVICE_ACCOUNT_NAME=$($pp.vacFLRServiceUserName)"
}

if ($pp.vacFLRServicePassword) {
  $silentArgs += " VAC_FLR_SERVICE_ACCOUNT_PASSWORD=$($pp.vacFLRServicePassword)"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName  = 'Application Server for Self-Service Portal for Veeam Agents*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination   = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

