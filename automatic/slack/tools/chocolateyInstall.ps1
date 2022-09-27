$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.28.184/prod/ia32/slack-standalone-4.28.184.0.msi'
$checksum32     = '4361c94d861ad68414d48aa6c7bd3439de03e391b481c449ea56fc41302bc0d8'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.28.184/prod/x64/slack-standalone-4.28.184.0.msi'
$checksum64     = '463dde7a7e90aaf6f5195a886006d1cb711d3a1c0637083e1c3552e481dfd9e8'
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

