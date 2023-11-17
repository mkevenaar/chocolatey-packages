$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-8.0.34-winx64.msi'
$checksum     = '231e6ad0d1e99707a90fc6e0f52a57242227dd28a8cb043a8ffbf0299fa1ef55'
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
