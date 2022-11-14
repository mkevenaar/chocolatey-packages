$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.29.149/prod/ia32/slack-standalone-4.29.149.0.msi'
$checksum32     = '2cda25ee9923c8464cfe89e0ba48caaf76347792c54476b6d3bc3849d78855ae'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.29.149/prod/x64/slack-standalone-4.29.149.0.msi'
$checksum64     = 'c67940bace38278bf1f0fa88880dd95c570202a12f8a1b44c27fcb65ae122ef9'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Slack*'
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

