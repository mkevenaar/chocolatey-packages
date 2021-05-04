$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.16.0/prod/ia32/slack-standalone-4.16.0.0.msi'
$checksum32     = 'db7c4a50f58e4eaf0ec50f461bd4502c9a9755a779349e81b6e1565fc0171556'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.16.0/prod/x64/slack-standalone-4.16.0.0.msi'
$checksum64     = '19b9b7383363c1a6c6972889c1a3350a5bf0d1dc53f1166719e011a76838b70c'
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

