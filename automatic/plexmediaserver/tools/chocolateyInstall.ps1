$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.3.7192-7aa441827/windows/PlexMediaServer-1.32.3.7192-7aa441827-x86.exe'
$checksum32     = '50d9c45a70968bf9e038a23590eae0815d275b4b9566f21fd9d62ddb0a9de550'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.3.7192-7aa441827/windows/PlexMediaServer-1.32.3.7192-7aa441827-x86_64.exe'
$checksum64     = '3ff8532c0e63c6b690807b952bd90b262bbd0966ef2f96bf892bf9f56b0f0ba8'
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
