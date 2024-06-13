$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.3.8555-fef15d30c/windows/PlexMediaServer-1.40.3.8555-fef15d30c-x86.exe'
$checksum32     = 'dc8ca44927393fcfa17ed2860a56bd7f01047ef80d36cab77a8fc5ad359266ca'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.3.8555-fef15d30c/windows/PlexMediaServer-1.40.3.8555-fef15d30c-x86_64.exe'
$checksum64     = '4f0f3ed8411332b4a02033673c0d35564c17e32011de58f5ddc30e8cd4793bc6'
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
