$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/slack-standalone-4.1.0.0.msi'
$checksum32     = '8aa40b7c02e0e1138e9dc910235081af4e79bc1f3ac649828e0e511b8004842d'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases_x64/slack-standalone-4.1.0.0.msi'
$checksum64     = '0a26ad8d5829e12799b19696619d240dabd8aa0c561c97fa89ae181e7e3bb5c0'
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

