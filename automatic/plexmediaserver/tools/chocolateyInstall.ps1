$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.2.9200-c6bbc1b53/windows/PlexMediaServer-1.41.2.9200-c6bbc1b53-x86.exe'
$checksum32     = 'd19f56c6f6147e2e30b469496133dc8dcbc287e1d5f2e969b811af151269fded'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.2.9200-c6bbc1b53/windows/PlexMediaServer-1.41.2.9200-c6bbc1b53-x86_64.exe'
$checksum64     = 'c88d78bf5ab6cab8b6139837c76277aa195b66808076f57105441d7d51d90507'
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
