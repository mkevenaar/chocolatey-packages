$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.5.7349-8f4248874/windows/PlexMediaServer-1.32.5.7349-8f4248874-x86.exe'
$checksum32     = '37c92326df99fef221755bc2392e618125da0066c5ee99ee663a0325abda0fce'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.5.7349-8f4248874/windows/PlexMediaServer-1.32.5.7349-8f4248874-x86_64.exe'
$checksum64     = 'e7b49fd8a957433b71de08b68b99654662890f283c21adaea780199379c04438'
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
