$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6973-a787c5a8e/windows/PlexMediaServer-1.32.0.6973-a787c5a8e-x86.exe'
$checksum32     = '7987e7f96e05e389de9270df76e2401ede914e19bf86a6753a5c79627b07583f'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6973-a787c5a8e/windows/PlexMediaServer-1.32.0.6973-a787c5a8e-x86_64.exe'
$checksum64     = '198a6000d98200072655d5b22009cb52b6edcd5bd1d95f88afa99f1331742d6e'
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
