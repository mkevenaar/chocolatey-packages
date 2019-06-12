$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/slack-standalone-3.4.3.0.msi'
$checksum32     = 'd9b39b27006dbaa2eeb8c53a2f10d0e9f601b80d59ccd7cab11070fbb0c23fe9'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases_x64/slack-standalone-3.4.3.0.msi'
$checksum64     = '9864f9f2cfb7c9681f666de0d5fa9f39b1aa7c143c4c66b63c2fb4d7aeb7e452'
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

