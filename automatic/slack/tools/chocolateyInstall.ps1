$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.19.0/prod/ia32/slack-standalone-4.19.0.0.msi'
$checksum32     = 'fffa5269df5cc5c3c7b8c16f0cf2cc07dd9a471a8ae4cd93372821f6306fb349'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.19.0/prod/x64/slack-standalone-4.19.0.0.msi'
$checksum64     = 'dc3d22e4a698d99608d64b1ee4b3f24cf270937149580ffc2de6dac5e6c42e61'
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

