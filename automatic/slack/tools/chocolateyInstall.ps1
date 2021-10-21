$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.21.0/prod/ia32/slack-standalone-4.21.0.0.msi'
$checksum32     = 'c87ebae5a02133d55583b6be6af337f6e3b42f0c4c5928d238c606431b9f788c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.21.0/prod/x64/slack-standalone-4.21.0.0.msi'
$checksum64     = '7a93cfcda4499724c542e7f551b62e31f90da489be09b48fddd1788ffe4c2518'
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

