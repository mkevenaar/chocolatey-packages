$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/charisma/youtrack-2021.1.9819.msi'
$checksum     = '50225cb9de51d3b0b0ab95ddc2d70cf53f29c6ddd9f8dec73417b34e9dd53fb1'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'JetBrains YouTrack*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
