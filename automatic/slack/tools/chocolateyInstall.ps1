$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/slack-standalone-4.1.1.0.msi'
$checksum32     = '9bbacd1ca90c73df73fdcc2845e2131e34b7615b18ed3fc47039784a7bbe2c00'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases_x64/slack-standalone-4.1.1.0.msi'
$checksum64     = '644d231f527d95f64b90e54ee4fb5e14b67dfddf9e9dd77c8697c488c4d465f1'
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

