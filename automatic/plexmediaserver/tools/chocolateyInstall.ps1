$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.43.0.10492-121068a07/windows/PlexMediaServer-1.43.0.10492-121068a07-x86.exe'
$checksum32     = 'bc978b73f3572d5838fdd495d121f3aef205c907c0a1a034ec8afaacb2db9c6a'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.43.0.10492-121068a07/windows/PlexMediaServer-1.43.0.10492-121068a07-x86_64.exe'
$checksum64     = '01031fb5309d77edc11f32662156199a67550c4246740c749f1f13cd3ec43785'
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
