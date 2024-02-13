$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.0.7998-c29d4c0c8/windows/PlexMediaServer-1.40.0.7998-c29d4c0c8-x86.exe'
$checksum32     = 'ffd2a13c686d4284546ede72f2f29c726da14fd39aa26b62b24d6a753707778e'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.0.7998-c29d4c0c8/windows/PlexMediaServer-1.40.0.7998-c29d4c0c8-x86_64.exe'
$checksum64     = 'b0f182c6c2599099644c05c27b23fa8e986d25a241f1c35f4bd1a0975ad84737'
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
