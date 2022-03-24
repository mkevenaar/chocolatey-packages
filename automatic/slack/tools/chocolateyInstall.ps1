$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.25.0/prod/ia32/slack-standalone-4.25.0.0.msi'
$checksum32     = '9d503c44bc23a8e7f721fda863995dfe6e89d7532138e9f967ec89a755d18055'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.25.0/prod/x64/slack-standalone-4.25.0.0.msi'
$checksum64     = 'df9ecc927929439aa2cb15030200b063ea372ce74e137f544f37570e215d5323'
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

