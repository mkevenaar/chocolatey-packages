$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.21.1/prod/ia32/slack-standalone-4.21.1.0.msi'
$checksum32     = 'aa98c6e8c0c0007e5ca81e8e46b7e28c284112301e10d48474cbb19276df9326'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.21.1/prod/x64/slack-standalone-4.21.1.0.msi'
$checksum64     = '7174737d3ec8da4ee6fc7a58d9d7111c3f085810855e164c1ffb392973181305'
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

