$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.4.9463-630c9f557/windows/PlexMediaServer-1.41.4.9463-630c9f557-x86.exe'
$checksum32     = 'e90566a2f6cb808173a4412066f43da30cbb8c39f0f4a370df4f4f1baf607be9'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.4.9463-630c9f557/windows/PlexMediaServer-1.41.4.9463-630c9f557-x86_64.exe'
$checksum64     = '4e4090866fa01ce60373f01d141f8b6b461161d16030875f8239492ebdec7d93'
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
