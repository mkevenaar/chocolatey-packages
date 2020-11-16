$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.11.2/prod/ia32/slack-standalone-4.11.2.0.msi'
$checksum32     = '7271b900eee71ea635e0530f69262407622326761f52ec725ed3483211609d44'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.11.2/prod/x64/slack-standalone-4.11.2.0.msi'
$checksum64     = '2033b9ed92e1c7ae7ae5275e7be087124fa1334e76bd1b5a9ed086d6cfb54a96'
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

