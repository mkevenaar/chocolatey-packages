$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.1.8227-c0dd5a73e/windows/PlexMediaServer-1.40.1.8227-c0dd5a73e-x86.exe'
$checksum32     = 'b7d1e3fa0b9bdd799482e13dc4ac3b0f18cb39fc729cffa67c410fc9f4e266f8'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.1.8227-c0dd5a73e/windows/PlexMediaServer-1.40.1.8227-c0dd5a73e-x86_64.exe'
$checksum64     = 'b12d852ceb0a0dce54957d7bb3726bf230cd40940ca658d9922f8f00aed118ae'
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
