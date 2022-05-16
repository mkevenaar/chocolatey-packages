$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.26.2/prod/ia32/slack-standalone-4.26.2.0.msi'
$checksum32     = '1759da2fb344014ef33270bad2fad55e619bc4659ca0ef2d0640d794c0ef4f90'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.26.2/prod/x64/slack-standalone-4.26.2.0.msi'
$checksum64     = 'a796e29cffd9efd873939a96db7af5922328f48991da6f11f65de5962be71a7f'
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

