$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8921-836b34c27/windows/PlexMediaServer-1.40.5.8921-836b34c27-x86.exe'
$checksum32     = '134d69333d3593ebbb4e7c8da25ab3f017086e4b873d31f0b8c76b5ee4da9859'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8921-836b34c27/windows/PlexMediaServer-1.40.5.8921-836b34c27-x86_64.exe'
$checksum64     = '7087cee962d145b8cd6db22c33150e745a556aa5bc67cadc3bdc9ddb7ed20113'
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
