$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.28.171/prod/ia32/slack-standalone-4.28.171.0.msi'
$checksum32     = '79f1b28f421d4948ccf3c9af7aa974c2a48d757e55df7ecaf24fb9fa3c14154d'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.28.171/prod/x64/slack-standalone-4.28.171.0.msi'
$checksum64     = '39dbc7fa2afb70ccc33517f465a4e585593c7cca37c4196d32989935e53eeb92'
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

