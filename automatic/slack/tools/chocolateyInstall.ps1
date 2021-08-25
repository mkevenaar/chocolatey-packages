$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.19.3/prod/ia32/slack-standalone-4.19.3.0.msi'
$checksum32     = '9ad2bf988bc69b6da683a069acc6d25a47d8ba32ef0e78cdf41da86fa705c586'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.19.3/prod/x64/slack-standalone-4.19.3.0.msi'
$checksum64     = '33bf8e0ab732e758bcf06ca339d1a26e40d18890eebb267a2a1128c30e5ef204'
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

