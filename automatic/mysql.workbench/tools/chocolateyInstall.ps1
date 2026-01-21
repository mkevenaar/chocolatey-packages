$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-8.0.46-winx64.msi'
$checksum     = 'f4664eb0ed7a3031d64212030f0faea045d155f397f428884455e8d240f3dfa3'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType       = 'msi'
  url           = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'MySQL Workbench*'
  silentArgs    = "/passive /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
