$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-8.0.25-winx64.msi'
$checksum     = 'b5be94e76ea87f0290b720e54829228db6c1101dd505682790006f3aa3cf3c75'
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
