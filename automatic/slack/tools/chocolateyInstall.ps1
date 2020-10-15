$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.10.3/prod/ia32/slack-standalone-4.10.3.0.msi'
$checksum32     = '6d28744779f7016ec8473c35c47ce40cf9b88e16c5942061b86df0cf27b4793c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.10.3/prod/x64/slack-standalone-4.10.3.0.msi'
$checksum64     = '6513990f0e547e2199a6fe2d0a0dec3aebbfa67424921e5f62ef3d935dd51598'
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

