$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.0.2.16660.exe'
$checksum     = '4d642ac91ab7920086373d9b90574fc058fa50812ccad5d9853a6b5a27949acf'
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
