$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.23.0/prod/ia32/slack-standalone-4.23.0.0.msi'
$checksum32     = '6bf724f3c60c00530fd55eafcdd6ac416f0d7975cec4c883fa000e680cb03deb'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.23.0/prod/x64/slack-standalone-4.23.0.0.msi'
$checksum64     = '97ec9c677b1a73ac784fccaee31246f41a782ecad09f269a3690190f7e939eef'
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

