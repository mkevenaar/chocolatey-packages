$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.5.0.84344.exe'
$checksum     = 'c4dc5d95a76bf2c0365e1dfb5ed7c76e80c1d3319e2467d18ec9af2ac1520ccf'
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
