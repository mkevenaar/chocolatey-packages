$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackupOffice365_4.0.0.2516.zip'
$checksum = '71300aa032b544d0a080682e40da243b363e607745157a1d1e6754fa1b321b87'
$checksumType = 'sha256'
$version = '4.0.0.2516'
$fileLocation = Join-Path $toolsDir "VeeamExplorerForExchange_$($version).msi"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam Explorer for Microsoft Exchange*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs     = "ACCEPT_EULA=1 ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs

