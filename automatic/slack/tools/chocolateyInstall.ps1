$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.26.0/prod/ia32/slack-standalone-4.26.0.0.msi'
$checksum32     = 'f8d1b53b2dbf136dec387e7d58982b7e296b43ce5bd4b34e8bcedf61e99e1ce2'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.26.0/prod/x64/slack-standalone-4.26.0.0.msi'
$checksum64     = '4e3c3403901f1b7b8b39e7c7cb6e1dd124c74a8bd05277d5ca57d0e80280eb91'
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

