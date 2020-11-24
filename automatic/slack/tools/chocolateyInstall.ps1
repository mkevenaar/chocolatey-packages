$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.11.3/prod/ia32/slack-standalone-4.11.3.0.msi'
$checksum32     = '18622bbbc7b1a3fc11cd0fc164fbf85a4d7b0bbd058f6749e18d77cbb72342e3'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.11.3/prod/x64/slack-standalone-4.11.3.0.msi'
$checksum64     = 'f5cb173e84ca178bd9520206b71dcec46b551e793cadc91ad033e00476180bd2'
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

