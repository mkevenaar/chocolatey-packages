$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'https://www.appveyor.com/downloads/appveyor-server/latest/windows/appveyor-server.msi'
$checksum32     = 'CB1A65DD974029FD21EF89783D44578F700B39369993094FFE0CF39477310020'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  softwareName  = 'AppVeyor Server*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
