$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/slack-standalone-4.1.2.0.msi'
$checksum32     = '506a286fd180579ce6c03d3e931d8b614b6f5690b6f26f968995489e66a5da1c'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases_x64/slack-standalone-4.1.2.0.msi'
$checksum64     = 'e92a66729f03d70b927717f63a985f3909f6b55934471e38080427d411bde5b6'
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

