$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum     = 'D5F0239F7C9A49C47BE6FF0F424FCF1102C2715B25C348FE634567D8E7E946E0'
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

