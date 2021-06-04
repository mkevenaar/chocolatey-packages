$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.17.0/prod/ia32/slack-standalone-4.17.0.0.msi'
$checksum32     = '7672a4f650af9539e1664bfbe838928e6ba96d06c0a4639f7fc34d96c472f838'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.17.0/prod/x64/slack-standalone-4.17.0.0.msi'
$checksum64     = 'e66f8417b2c00b6c6f8421677ca587fea26e855db3e56b2d6e58ee4ff1234b50'
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

