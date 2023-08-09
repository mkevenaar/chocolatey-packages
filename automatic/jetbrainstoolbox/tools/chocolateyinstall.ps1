$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.0.1.16621.exe'
$checksum     = '25c538cbf8c4437b24dad3b2bc0bef27097faf075aaf06c06cdd5aee98429882'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'JetBrains Toolbox*'
  fileType       = 'exe'
  silentArgs     = '/S /ju'
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
