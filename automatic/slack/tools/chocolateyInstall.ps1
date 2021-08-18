$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.19.2/prod/ia32/slack-standalone-4.19.2.0.msi'
$checksum32     = '9a7ab61ec52f74728359fe365470e629049f7d1015737041e8f7b08ee79e9404'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.19.2/prod/x64/slack-standalone-4.19.2.0.msi'
$checksum64     = '41e202a9456d02bd3c3253c229115833e7195460d9d06365fb0ca48a4b5fac20'
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

