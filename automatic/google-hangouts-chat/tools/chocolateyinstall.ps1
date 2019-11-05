$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/chat/19.9.101/InstallHangoutsChat.msi'
$checksum     = '2f9828825337a99b4be3c84497fe4e768e9dbdd3658e7e2f3923dab084512603'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'msi'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Hangouts Chat*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
