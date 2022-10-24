$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.29.144/prod/ia32/slack-standalone-4.29.144.0.msi'
$checksum32     = '74d7c95bec39d10745534958e376558f5d448c5c2f9fe8f6ab51dc53d86b128a'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.29.144/prod/x64/slack-standalone-4.29.144.0.msi'
$checksum64     = 'af5c3b6eec2387f1cd39f367bf1cfbceecade3439568644301eebeab6b1e0a1e'
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

