$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://iweb.dl.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04-setup.exe'
$checksum     = '4e1db5a7400e348b1b46a4a11b6d9557fd84368e4ad3d4bc4c1be636c89638aa'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Nullsoft Install System*'
  silentArgs     = '/S'
  validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @packageArgs
