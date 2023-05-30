$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.32.126/prod/ia32/slack-standalone-4.32.126.0.msi'
$checksum32     = 'd9094ae309f9a4dc9f3e77523d0bd97bf9f14a36cd53b5fb328075c3c28ed218'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.32.126/prod/x64/slack-standalone-4.32.126.0.msi'
$checksum64     = 'aaf6e564a1476bf4e79e58fb6e5b9e9f0892f937653ab93b700d331e969b705a'
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

