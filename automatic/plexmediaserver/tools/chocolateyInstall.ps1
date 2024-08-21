$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8897-e5987a19d/windows/PlexMediaServer-1.40.5.8897-e5987a19d-x86.exe'
$checksum32     = '0d732c4dc06ec47aedf1f992ab0d29137b1e6ffc7d5c53247624fa6ed6ccd1ff'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8897-e5987a19d/windows/PlexMediaServer-1.40.5.8897-e5987a19d-x86_64.exe'
$checksum64     = '5ee50b41abe294b2735ee080c52c48e6bb5cf08689e44c15027f0ca50199f5d4'
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
