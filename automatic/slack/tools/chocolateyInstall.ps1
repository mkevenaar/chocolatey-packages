$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.16.1/prod/ia32/slack-standalone-4.16.1.0.msi'
$checksum32     = '4668edf054d2e4b9da163c0f4edadaa79947ae5cb660ad45c6e403ed8b6acd21'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.16.1/prod/x64/slack-standalone-4.16.1.0.msi'
$checksum64     = '2df775430a6c4e006dbfc7ee1317fa2e8294f63269142365269b6504830e62e6'
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

