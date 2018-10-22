$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.anyrail.com/downloads/AnyRail/6.17/AnyRail6.17.4.msi'
$checksum     = '9ff33e2aa204cbb6ab05f98261662e8bef74f76ebc2cd4d5931c6e3ace5d691c'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url

  softwareName   = 'AnyRail6*'

  checksum       = $checksum
  checksumType   = $checksumType

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
