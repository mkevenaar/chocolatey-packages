$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.6.7468-07e0d4a7e/windows/PlexMediaServer-1.32.6.7468-07e0d4a7e-x86.exe'
$checksum32     = '2bf164943bc61023f7e4a85efc0cdcfaba973728b14fb64f690d7d20526756a3'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.6.7468-07e0d4a7e/windows/PlexMediaServer-1.32.6.7468-07e0d4a7e-x86_64.exe'
$checksum64     = '9e0e520a766c07d127a6a33373ba16dda47b3f4bb23023b558e05468f160451a'
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
