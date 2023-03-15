$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.31.2.6810-a607d384f/windows/PlexMediaServer-1.31.2.6810-a607d384f-x86.exe'
$checksum32     = '49a08ddc9765c8d37c36ddd52440a209db218597a1f995cbec29cb2a2adb7ed4'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.31.2.6810-a607d384f/windows/PlexMediaServer-1.31.2.6810-a607d384f-x86_64.exe'
$checksum64     = '63a8c1d209571e1f283c6abdd7bfd8b042dd44f3de43c2d08e41bc92fd1d667c'
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
