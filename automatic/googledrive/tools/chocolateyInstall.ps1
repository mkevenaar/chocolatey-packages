$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum     = 'DDCD804F934304E695C513741857C3D01865D24FE551286E56E5F2B52FE73FD7'
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

