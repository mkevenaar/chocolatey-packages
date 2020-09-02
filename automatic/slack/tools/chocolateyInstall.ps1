$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.9.0/prod/ia32/slack-standalone-4.9.0.0.msi'
$checksum32     = 'ce664c14615e11b33b2e7455f2af64f06509e3d6f92fbc4288c7f640e77b8acf'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.9.0/prod/x64/slack-standalone-4.9.0.0.msi'
$checksum64     = '631ab1d63f3b3a980cd6401efd1fb2c1b9f85d0e1a9664b81dc820216e462d9a'
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

