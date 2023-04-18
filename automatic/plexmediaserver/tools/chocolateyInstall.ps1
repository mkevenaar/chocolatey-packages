$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6950-8521b7d99/windows/PlexMediaServer-1.32.0.6950-8521b7d99-x86.exe'
$checksum32     = 'bb4bd85e8c527cbc1a02435c0f36682aec13c161206897aa2ffe64f44b958c0d'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.0.6950-8521b7d99/windows/PlexMediaServer-1.32.0.6950-8521b7d99-x86_64.exe'
$checksum64     = '6fb3b26e609c8016cf6216e3954f2efbc757702fda9a0c38d8bc27f9bd88bd48'
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
