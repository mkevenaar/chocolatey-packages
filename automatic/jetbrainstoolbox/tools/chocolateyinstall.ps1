$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.15.5666.exe'
$checksum     = 'ddea3aa3033842bf3eb2c288f83b55a236cf78eb7243323036579c73aacc98fa'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'JetBrains Toolbox*'
  fileType      = 'exe'
  silentArgs   = '/S'
  validExitCodes= @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
