$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6918-6f393eda1/windows/PlexMediaServer-1.32.0.6918-6f393eda1-x86.exe'
$checksum32     = '95a4fb7775c9d7c314f68d1882dae929a114a9d72c7b5975fa89d743663e61f3'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6918-6f393eda1/windows/PlexMediaServer-1.32.0.6918-6f393eda1-x86_64.exe'
$checksum64     = '7d2e9f46f013844dd22ef186a7b3e43845de01b138fef44d96f9e7f7b9330c04'
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
