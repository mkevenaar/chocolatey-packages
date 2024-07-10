$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.40.4.8679-424562606/windows/PlexMediaServer-1.40.4.8679-424562606-x86.exe'
$checksum32     = '8ed300fa9320a273d1a28d614dbe8a003a74579364afb37c7fff21f51eb16809'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.40.4.8679-424562606/windows/PlexMediaServer-1.40.4.8679-424562606-x86_64.exe'
$checksum64     = 'c2f54fbe16275106990cf7a792d2808aabae70915c0d938d3130fd298902f39e'
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
