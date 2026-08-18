$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/windows/PlexMediaServer-1.42.2.10156-f737b826c-x86.exe'
$checksum32     = '7f472ccf09c652b03c1a16e2beb11590ed7c61dc613dd7d98cc8d4d08d6b974b'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.43.3.10896-cb3ebc72d/windows/PlexMediaServer-1.43.3.10896-cb3ebc72d-x86_64.exe'
$checksum64     = '92f1d6277b9cde5ad6c9b059e679276bca581d62a1299c9f77b15e541a70e3f3'
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
