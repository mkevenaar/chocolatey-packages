$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum     = '0548997358D35195139BB2C3AAD55AD19ACBEBC0CEBCFA45D781F06F4C49BA51'
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

