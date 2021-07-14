$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.18.0/prod/ia32/slack-standalone-4.18.0.0.msi'
$checksum32     = '3cad47d22b22d5460becc95b7f75700191e715cc05921646dd11e938d12b6f90'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.18.0/prod/x64/slack-standalone-4.18.0.0.msi'
$checksum64     = '7821699675bc67b63d1c7f2eb08dfc41ce3359d4d3cb37742ddb74090073eb1c'
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

