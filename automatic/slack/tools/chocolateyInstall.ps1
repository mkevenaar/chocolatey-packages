$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.26.3/prod/ia32/slack-standalone-4.26.3.0.msi'
$checksum32     = '2243800f5774c0da80d9a746ebf801b37c3f0c0366fd9c042defee88ac4938fc'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.26.3/prod/x64/slack-standalone-4.26.3.0.msi'
$checksum64     = 'd4cd040e49028ad985b0c2212aa3148af1103547c3f486960d0d7eacc6cfe7a5'
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

