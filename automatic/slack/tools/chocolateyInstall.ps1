$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/slack-standalone-4.0.0.0.msi'
$checksum32     = '3ae1f17cfc0b24f57c93a32c546ed9d30ec69f12ce1b786f982b8ba86bd83c44'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases_x64/slack-standalone-4.0.0.0.msi'
$checksum64     = '94830d25a7d5afe8fe40b1f0f1c5f2f2a1e55f0b957363b7af02cb6ba2a56538'
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

