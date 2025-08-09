$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.42.1.10054-f333bdaa8/windows/PlexMediaServer-1.42.1.10054-f333bdaa8-x86.exe'
$checksum32     = '0079e6b66a4fa5dcd3eac5af0108e7eb936a3b15ac96d6bb98aa8db9d07b6661'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.42.1.10054-f333bdaa8/windows/PlexMediaServer-1.42.1.10054-f333bdaa8-x86_64.exe'
$checksum64     = '6c67978f5083c8c692fb648c32b595413ab1fb584e01362c0e800be9972d1f6a'
$checksumType64 = 'sha256'

Start-CheckandStop "Plex Media Server"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'plexmediaserver*'
  silentArgs    = '/quiet /VERYSILENT'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
