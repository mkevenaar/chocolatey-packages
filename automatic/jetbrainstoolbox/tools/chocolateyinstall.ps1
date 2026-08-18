$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.7.0.87111.exe'
$checksum     = '9e044fe4db7ea15bccf0cab8f78033b6fd4e9042c7834e96402be5c2cbb09348'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'JetBrains Toolbox*'
  fileType       = 'exe'
  silentArgs     = '/s /headless'
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
