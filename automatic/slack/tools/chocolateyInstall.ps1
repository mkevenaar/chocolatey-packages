$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.31.155/prod/ia32/slack-standalone-4.31.155.0.msi'
$checksum32     = '902328736a4d587c9753172c3de1cb42bc1d1a170fcc397a177188589a0bd770'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.31.155/prod/x64/slack-standalone-4.31.155.0.msi'
$checksum64     = '80aa728dd0c9cb30979bd9580f416a3c0194901a35faaf59342a3e48f034ee02'
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

