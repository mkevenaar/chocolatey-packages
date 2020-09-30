$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_4_5_4.exe'
$checksum32     = 'dd9a92cf5adb14e2ad1dc3b1f93e95743b5de941cc352c40459e3f8497166ff2'
$checksumType32 = 'sha256'
$url64          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_4_5_4_x64.exe'
$checksum64     = '249cd1305b54960c2222b8d9c7457f11309465799470b11e617f0e06a8b40932'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'OpenFire*'
  silentArgs     = '-q'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
