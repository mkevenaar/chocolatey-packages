$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.8.9834-071366d65/windows/PlexMediaServer-1.41.8.9834-071366d65-x86.exe'
$checksum32     = '6f99da147b4872ef1ca4707bed7c8e27e53b10c6434a95eb213e29bdbb411c58'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.8.9834-071366d65/windows/PlexMediaServer-1.41.8.9834-071366d65-x86_64.exe'
$checksum64     = '4fad65ad99552f51f36affe8d8d67a0cba7edfa400cae93ccbf92d05c1df2ecb'
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
