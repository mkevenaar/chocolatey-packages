$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.33.73/prod/ia32/slack-standalone-4.33.73.0.msi'
$checksum32     = '144c85309f28518a22ff5b97804d11f385e49f1b65410095fcb8c249d9702112'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.33.73/prod/x64/slack-standalone-4.33.73.0.msi'
$checksum64     = 'ff139335769cd35c23486e6dd65d48d679e3752d9e755ee512e2e46dc23beeb6'
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

