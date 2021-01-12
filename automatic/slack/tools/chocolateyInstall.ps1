$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.12.2/prod/ia32/slack-standalone-4.12.2.0.msi'
$checksum32     = 'bca425a6e90660d8a1156f3cf4a55e9fc97d9a4f920086e4797c32b19fa3c950'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.12.2/prod/x64/slack-standalone-4.12.2.0.msi'
$checksum64     = '281b3b5bdda1fd7041e74f64659167816084c6869d5bf43dde31e0b578c35a38'
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

