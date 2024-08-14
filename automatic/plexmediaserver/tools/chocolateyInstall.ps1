$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8854-f36c552fd/windows/PlexMediaServer-1.40.5.8854-f36c552fd-x86.exe'
$checksum32     = '5e262673c519f6990873fdc8cd8776c4e0ab2f3beaa6be4e786bf4d7d801f099'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.5.8854-f36c552fd/windows/PlexMediaServer-1.40.5.8854-f36c552fd-x86_64.exe'
$checksum64     = '208a454a7613fc7d1e1aa9563aae0d044eaf9660c7bfd827883d4f9fa7806f71'
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
