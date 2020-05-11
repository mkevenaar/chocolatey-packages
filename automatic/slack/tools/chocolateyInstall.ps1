$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.5.1/prod/ia32/slack-standalone-4.5.1.0.msi'
$checksum32     = '79cd42698f26a19deb02e2af0d874f2353ccabc5d5e2c2f996698563b66dedbe'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.5.1/prod/x64/slack-standalone-4.5.1.0.msi'
$checksum64     = '4bbdbd46724a6685830ac5d8c32f61a11c4462bc25f69290a9c83b1f888390e6'
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

