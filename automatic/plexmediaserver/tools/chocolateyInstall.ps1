$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.31.1.6782-77dfff442/windows/PlexMediaServer-1.31.1.6782-77dfff442-x86.exe'
$checksum32     = '89f6cf3bccdf0a52f6e44319fadf4e3baa6fb23b855fd9ab90725d40b9e014c8'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.31.1.6782-77dfff442/windows/PlexMediaServer-1.31.1.6782-77dfff442-x86_64.exe'
$checksum64     = '9a78b98e5c67d831ae90e84a482830caff80defb4eda95fa40a94b9bcd79517c'
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
