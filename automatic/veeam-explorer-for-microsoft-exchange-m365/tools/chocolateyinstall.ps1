$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-backup-for-microsoft-365-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamBackupMicrosoft365_8.2.0.2008.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Explorers\VeeamExplorerForExchange.msi'
$updateFileLocation = "Patches\VeeamExplorerForExchange.msp"

[System.Collections.ArrayList]$silentArgs = @()

$silentArgs.Add('BR_EXCHANGEEXPLORER')
$silentArgs.Add('PS_EXCHANGEEXPLORER')

$silent = $silentArgs -join ','

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam Explorer for Microsoft Exchange*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "/qn /norestart ADDLOCAL=$($silent) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

# An update file is provided in the ISO. This should be executed after
# the installation of the software.
#
# This should be in a seperate package, but you can't trigger / force a
# dependency after the installation Therefore I need to trigger it this way.
If ($filename -Match "_P") {
  $updatePackageArgs = @{
    packageName    = $env:ChocolateyPackageName
    isoFile        = $installPath
    softwareName   = $packageArgs['softwareName']
    file           = $updateFileLocation
    fileType       = 'msp'
    silentArgs     = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
    validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
    destination    = $toolsDir
  }

  Install-ChocolateyIsoInstallPackage @updatePackageArgs
}
