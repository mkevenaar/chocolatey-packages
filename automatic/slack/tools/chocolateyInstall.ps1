$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.27.154/prod/ia32/slack-standalone-4.27.154.0.msi'
$checksum32     = 'fed9d743bd0dca07d320ae77b81d119e5149cd4cba26050b3a95a9dd3db07841'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.27.154/prod/x64/slack-standalone-4.27.154.0.msi'
$checksum64     = '5fe92e297cc05a854064e6ebef7fdc6ba34f32854d4709bdba849d0386ac4fbf'
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

