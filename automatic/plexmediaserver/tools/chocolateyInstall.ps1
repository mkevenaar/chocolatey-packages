$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.5.9522-a96edc606/windows/PlexMediaServer-1.41.5.9522-a96edc606-x86.exe'
$checksum32     = '74b973c4714643df0ebc3c4b9b9e63c9de5c52646d9657c65a56b383dc3c7c51'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.5.9522-a96edc606/windows/PlexMediaServer-1.41.5.9522-a96edc606-x86_64.exe'
$checksum64     = '02b27e76ca3ca8971b666e189f98dd892bb0d66eb2d6d6499e4aaa86a102a058'
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
