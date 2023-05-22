$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.2.7100-248a2daf0/windows/PlexMediaServer-1.32.2.7100-248a2daf0-x86.exe'
$checksum32     = '801e9e80ae3342a52a0976ec5e62639b65b503522ccb8953780e32db7c7a2ac7'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.2.7100-248a2daf0/windows/PlexMediaServer-1.32.2.7100-248a2daf0-x86_64.exe'
$checksum64     = '509d630621c5c61ea5b9e44004aac19d393ca04668dd5c63416c2f0bc4fff500'
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
