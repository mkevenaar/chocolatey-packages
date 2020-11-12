$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.11.1/prod/ia32/slack-standalone-4.11.1.0.msi'
$checksum32     = 'f59697362b909898065c77be74d8ee01da067baa0900a13731098c1cba651863'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.11.1/prod/x64/slack-standalone-4.11.1.0.msi'
$checksum64     = '6eb9d934aea4305237a6698f4b6fa4d2477789a661e310af4e2e3497ec138c48'
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

