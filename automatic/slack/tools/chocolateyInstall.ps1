$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.17.1/prod/ia32/slack-standalone-4.17.1.0.msi'
$checksum32     = 'a1dd695a006a2b4fcd2bace8808b626fc0712d0410ffc5485a2d99fb16347cfe'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.17.1/prod/x64/slack-standalone-4.17.1.0.msi'
$checksum64     = 'fe99d7f3a376cf5aa10b2ca1df29143de5a4b7201c7d5d6a9301f4cb7aa274ce'
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

