$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.0.8994-f2c27da23/windows/PlexMediaServer-1.41.0.8994-f2c27da23-x86.exe'
$checksum32     = 'c3d26056ceb3a2a71990f9c3b76535606e013b9eddd3ff9f8e4c178545bf02d3'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.0.8994-f2c27da23/windows/PlexMediaServer-1.41.0.8994-f2c27da23-x86_64.exe'
$checksum64     = 'eac6368914e678a6155f0837c0bd6fbf0bdd137a81ea11ff56be30f19ddfc7e2'
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
