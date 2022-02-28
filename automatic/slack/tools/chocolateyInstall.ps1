$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.24.0/prod/ia32/slack-standalone-4.24.0.0.msi'
$checksum32     = '04cc3a573806d152a43c8720c93a4c22c17ae3d4dfdf53a9ebad4e9660b16b17'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.24.0/prod/x64/slack-standalone-4.24.0.0.msi'
$checksum64     = '8f9b0375827d58ceebe54d8af9d4baabf2503dc976d10528a07a3df923598c9e'
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

