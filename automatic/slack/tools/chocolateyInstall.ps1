$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.26.1/prod/ia32/slack-standalone-4.26.1.0.msi'
$checksum32     = 'ae2c666023521c5aca2ab0ce07b18659c1e74f91333571182ed09326ac26e314'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.26.1/prod/x64/slack-standalone-4.26.1.0.msi'
$checksum64     = '89504b92a26cbf8e6ee3499babf791493b657c27c8c114387e15d97591897cfc'
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

