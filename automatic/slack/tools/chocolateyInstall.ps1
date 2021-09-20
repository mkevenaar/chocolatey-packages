$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.20.0/prod/ia32/slack-standalone-4.20.0.0.msi'
$checksum32     = '49bc39d6a63c1eece6fe37c2ee0e62bd2ea928af56d50f59ce1f0817a4d3da0e'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.20.0/prod/x64/slack-standalone-4.20.0.0.msi'
$checksum64     = 'd717d5a2da57235bf93766ba66303d7bf941b5fda77bca5b5acaf80c2da27a06'
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

