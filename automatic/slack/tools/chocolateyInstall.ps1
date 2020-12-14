$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.12.0/prod/ia32/slack-standalone-4.12.0.0.msi'
$checksum32     = '529cdcb3da86c58fd57abda20160a7db0ea9eb5130c567078f6bb4ed1535dea2'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.12.0/prod/x64/slack-standalone-4.12.0.0.msi'
$checksum64     = '5187ba9507cc5e56f93fa96f7ed3b66a86d2e762e4e89e27cbadc5971f7d0168'
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

