$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.0.8992-8463ad060/windows/PlexMediaServer-1.41.0.8992-8463ad060-x86.exe'
$checksum32     = '8bf3e5f053560f2f53fa355f923f621dc286162a4dad59bbbde20515b8b2e9db'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.0.8992-8463ad060/windows/PlexMediaServer-1.41.0.8992-8463ad060-x86_64.exe'
$checksum64     = '146975b05dab43c632f5d3144c79f3f2152ed369c56d4932a08075c1b71cb8c6'
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
