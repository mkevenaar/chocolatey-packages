$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.25.2/prod/ia32/slack-standalone-4.25.2.0.msi'
$checksum32     = '97fe774fae88d6683f810379de18c7bc77d956773399f870d88dc1c3ffe2f30c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.25.2/prod/x64/slack-standalone-4.25.2.0.msi'
$checksum64     = '16b7dab0d2a89d0c48153d3729710a650bea3def04dac2dbb7aa00726b7a258c'
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

