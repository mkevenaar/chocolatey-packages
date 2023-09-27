$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.32.6.7557-1cf77d501/windows/PlexMediaServer-1.32.6.7557-1cf77d501-x86.exe'
$checksum32     = 'b3cd875018c1de0a60e6a7e542c6bd0a2b522a7cb2916df7eddbb20244712b6c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.32.6.7557-1cf77d501/windows/PlexMediaServer-1.32.6.7557-1cf77d501-x86_64.exe'
$checksum64     = '0eb63f9961624f152fd0d3f38ddbdacdbf46e0a1709dcbcd3ac5e8d02df41fd3'
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
