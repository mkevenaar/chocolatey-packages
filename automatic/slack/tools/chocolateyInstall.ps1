$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.32.122/prod/ia32/slack-standalone-4.32.122.0.msi'
$checksum32     = '3c1b28121a82659590c8ececdb1f3b65185317f8fd03e80d543d68553704c2b7'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.32.122/prod/x64/slack-standalone-4.32.122.0.msi'
$checksum64     = '2af678ec5c282ecb12ca7b8b404241f17cfd73fca1917bf2a941302d8a9bef62'
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

