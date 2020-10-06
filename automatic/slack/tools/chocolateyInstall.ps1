$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.10.0/prod/ia32/slack-standalone-4.10.0.0.msi'
$checksum32     = '1ca6961dd2a205efadacd5b7a0832fb8102a2aaa98f3eebbaf6068efa3b5e348'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.10.0/prod/x64/slack-standalone-4.10.0.0.msi'
$checksum64     = '57d91ee0bd39f1f5c19753c5b5bb587af136ab9cb7a037cb9a5c5f57bbb5bae4'
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

