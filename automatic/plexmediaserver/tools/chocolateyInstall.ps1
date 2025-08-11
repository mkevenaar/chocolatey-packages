$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.42.1.10060-4e8b05daf/windows/PlexMediaServer-1.42.1.10060-4e8b05daf-x86.exe'
$checksum32     = 'cbc09473bec3906f3cb3d2c82c8fc4a200a4ba8484aa9c6fdeb08c2b01d24e60'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.42.1.10060-4e8b05daf/windows/PlexMediaServer-1.42.1.10060-4e8b05daf-x86_64.exe'
$checksum64     = '96ba2e0455bfded4ce8dfb265cc88d4cc9508df06d3f62e6abc26a4bac574ab2'
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
