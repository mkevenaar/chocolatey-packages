$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.22.0/prod/ia32/slack-standalone-4.22.0.0.msi'
$checksum32     = 'c70abdd0ef0ddaac0a61c3edf85a288127cb91ae0566975f96986171e27fd789'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.22.0/prod/x64/slack-standalone-4.22.0.0.msi'
$checksum64     = 'aa61fad61537544f315499b183c237ad7e147ecf980ec800fd2c77163d0b7213'
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

