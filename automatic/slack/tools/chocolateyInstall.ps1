$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.15.0/prod/ia32/slack-standalone-4.15.0.0.msi'
$checksum32     = 'b8297b1379ea81cc3af627b0e5c39008ef5f8bff172575757d3be60d1a3fb413'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.15.0/prod/x64/slack-standalone-4.15.0.0.msi'
$checksum64     = 'b11fa24849935d53be47b5f98eb14512f7544c0e8c32fc8b1cde49b3b520b736'
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

