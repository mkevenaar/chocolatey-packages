$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.7.7621-871adbd44/windows/PlexMediaServer-1.32.7.7621-871adbd44-x86.exe'
$checksum32     = '888d50de57c6635635a4eef8a94f9b685585b3340f3138c3a6a7afbe6e64c412'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.7.7621-871adbd44/windows/PlexMediaServer-1.32.7.7621-871adbd44-x86_64.exe'
$checksum64     = '8974dde592580aae10b6d3690e2958aa41bb16fa0f973402b700a36a36fb691a'
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
