$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.31.152/prod/ia32/slack-standalone-4.31.152.0.msi'
$checksum32     = '725f3911e017a3d283ae98d995360523e5e8458fb646ab32433aa60b63bea2f6'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.31.152/prod/x64/slack-standalone-4.31.152.0.msi'
$checksum64     = 'adf99c2c2521781d66991395551a944542ac3405902c0791a5535e02baef8e4d'
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

