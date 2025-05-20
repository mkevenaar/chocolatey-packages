$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.41.7.9799-5bce000f7/windows/PlexMediaServer-1.41.7.9799-5bce000f7-x86.exe'
$checksum32     = 'e9b84ce9658d070ae56d4a553a1b68cb3a893b0254742a301762ed373e6e1dc1'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.41.7.9799-5bce000f7/windows/PlexMediaServer-1.41.7.9799-5bce000f7-x86_64.exe'
$checksum64     = 'fecf6963af5376e2e768ebcd804c2c02031036613b0b567523646e53d5da5237'
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
