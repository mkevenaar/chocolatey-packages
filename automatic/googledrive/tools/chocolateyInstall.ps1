$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum     = '2CB39F4B8E640944C83E7EEE34F0F886B58DF23FA4141C225714CD6646B96575'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Google Drive*'
  silentArgs    = "--silent --desktop_shortcut"
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

