$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.11.0/prod/ia32/slack-standalone-4.11.0.0.msi'
$checksum32     = 'f08e96dde74d15e07960f629d524d9977c90475c91541634733edb3884b49932'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.11.0/prod/x64/slack-standalone-4.11.0.0.msi'
$checksum64     = '13667ea7ab518a053eb648c3f684b47083781322ca8bddf91c5aa232ea2cf2af'
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

