$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.2.8395-c67dce28e/windows/PlexMediaServer-1.40.2.8395-c67dce28e-x86.exe'
$checksum32     = '042f2bb26ba2c7bf69d5ab7fcec226af707a1b111b28dbc265a43ba742169d67'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.2.8395-c67dce28e/windows/PlexMediaServer-1.40.2.8395-c67dce28e-x86_64.exe'
$checksum64     = '43f2d9ef322e66b456bfcc8a43594cb9bdd708d55ed9ba56d0844ced8c1645b0'
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
