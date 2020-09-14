$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/charisma/youtrack-2020.3.9516.msi'
$checksum     = '2f445ac8fde95044103cdd1938044d62c3b22c81c05611572663beadb5657263'
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
