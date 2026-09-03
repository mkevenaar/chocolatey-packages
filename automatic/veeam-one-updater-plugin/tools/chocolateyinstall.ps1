$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE_13.1.0.7233_20260821.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename
$isoToolsPath = Join-Path (Join-Path $commonPath $isoPackageName) 'tools'
$settingsFile = Join-Path $isoToolsPath 'VOSettings.xml'

if (-not (Test-Path -LiteralPath $installPath)) {
  throw "Unable to locate ISO source '$installPath'. Ensure dependency '$isoPackageName' is installed."
}

$fileLocation = 'Updater\VeeamOneUpdaterPlugin.msi'

$silentArgs = New-Object System.Collections.Generic.List[string]

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
  softwareName   = 'Veeam Updater Plug-in for Veeam ONE*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = $msiSilentArgs
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

$patchArgs = @{
  PackageName  = $env:ChocolateyPackageName
  IsoFile      = $installPath
  SettingsFile = $settingsFile
  SilentArgs   = $msiSilentArgs
  ValidExitCodes = @(0,1638,1641,3010)
  Destination  = $toolsDir
  ProductName  = 'VeeamOneUpdaterPlugin'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
