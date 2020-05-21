$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.6.0/prod/ia32/slack-standalone-4.6.0.0.msi'
$checksum32     = '2afb5e2636a86fb484c4b7db5f5bbe839c6a58f3ad3d04991e0214503597b54a'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.6.0/prod/x64/slack-standalone-4.6.0.0.msi'
$checksum64     = '12d3b47e7bd5ad2c48cf2c49525045626258f3ed030d7425941827df7d69384d'
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

