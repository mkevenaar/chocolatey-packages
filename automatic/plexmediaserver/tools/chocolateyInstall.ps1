$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.5.7328-2632c9d3a/windows/PlexMediaServer-1.32.5.7328-2632c9d3a-x86.exe'
$checksum32     = '63068bd2aa1364375703b1248bb1bcd6ebc0490bf97381994561e8e6c9bbf8e8'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.5.7328-2632c9d3a/windows/PlexMediaServer-1.32.5.7328-2632c9d3a-x86_64.exe'
$checksum64     = '7d2da1cad6fce97797e507cc5ec0e4d5697cfde1dff05eff91a46e640372dbeb'
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
