$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.3.9314-a0bfb8370/windows/PlexMediaServer-1.41.3.9314-a0bfb8370-x86.exe'
$checksum32     = '384c8ad93af5099f3c87949a6709116d0cf5b1f65ae2cdcfa87389928b7946d6'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.3.9314-a0bfb8370/windows/PlexMediaServer-1.41.3.9314-a0bfb8370-x86_64.exe'
$checksum64     = '14442e4f520e6450529d1ae6ff9538ee7acb6f7d8ad42e25e2cbb7ae699ea9ec'
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
