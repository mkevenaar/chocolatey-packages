$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
$checksum = '86783FF5907DE0A85D21738E0A20E502F4D27AC84DBFA3B1232A3EF27A297D26'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Google Drive*'
  silentArgs     = "--silent --desktop_shortcut --skip_launch_new"
  validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs

