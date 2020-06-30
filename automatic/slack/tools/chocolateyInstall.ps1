$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.7.0/prod/ia32/slack-standalone-4.7.0.0.msi'
$checksum32     = 'd72b7a93a22dc73e3c835bc01dfd8937c1b48d9a0c87d41c8bd64ac8b0777a08'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.7.0/prod/x64/slack-standalone-4.7.0.0.msi'
$checksum64     = '9abe62bcf394ecbccae4ac5c0261c7fc55b16fcd7635f63650d39e5a67bcea95'
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

