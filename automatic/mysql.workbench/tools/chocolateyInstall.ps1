$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-8.0.31-winx64.msi'
$checksum     = 'aa08256733cf84069366d7a98996dbc1d757674aabadcc8faa3c899cc66fafb1'
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
