$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.28.182/prod/ia32/slack-standalone-4.28.182.0.msi'
$checksum32     = '5b49c946141aa6f104073116ba667aed9b161f62499c8a29514b85027907a02e'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.28.182/prod/x64/slack-standalone-4.28.182.0.msi'
$checksum64     = '8c0b8a789e0c3cfedf73e0147ee0a2e9a73b7f5079277b9ed9195ea4bdec11b3'
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

