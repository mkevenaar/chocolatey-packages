$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/chat/20.8.301/InstallHangoutsChat.msi'
$checksum     = '8ca8410ac4fcbc4b896006928e3616c8dc72303dccd7a9364b7a25f66d4e4398'
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
