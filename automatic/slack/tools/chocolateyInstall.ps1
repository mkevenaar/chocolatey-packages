$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.13.0/prod/ia32/slack-standalone-4.13.0.0.msi'
$checksum32     = 'ba3815559645012ca70946d9ddfc753fe090dc7baa878ba4f2798953a9984708'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.13.0/prod/x64/slack-standalone-4.13.0.0.msi'
$checksum64     = 'd722c4b4a0ea402c0697424d33ef6544614ebf0facca73f64c9d9270674a62ff'
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

