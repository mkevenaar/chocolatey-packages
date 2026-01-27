$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.43.0.10467-2b1ba6e69/windows/PlexMediaServer-1.43.0.10467-2b1ba6e69-x86.exe'
$checksum32     = 'cee9bd2e4452ea513ba3dfd595e770c3813434e503a8facb2f1e218e5e779254'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.43.0.10467-2b1ba6e69/windows/PlexMediaServer-1.43.0.10467-2b1ba6e69-x86_64.exe'
$checksum64     = 'ff4de4012f4b9529fb0ebbc42b7f3a1871a92230791d7881b2c3541586999b1f'
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
