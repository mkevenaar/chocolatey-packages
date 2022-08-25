$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum     = '28C76EE7126D5BF1539EDDBBE599DABF86BAA936A2C90B5E48F3D7ECF302B9B6'
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

