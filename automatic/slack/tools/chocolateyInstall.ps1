$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.33.90/prod/ia32/slack-standalone-4.33.90.0.msi'
$checksum32     = '6f2d056c61104dd71634f62c3a0bae26259340129ac13791548bd47e97262c69'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.33.90/prod/x64/slack-standalone-4.33.90.0.msi'
$checksum64     = '0c2ea223f0a0477c82568d74a4ca6988b33cc7d1cf22a2c358aee54ca26879ad'
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

