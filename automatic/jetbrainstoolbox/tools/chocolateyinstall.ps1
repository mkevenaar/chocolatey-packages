$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.0.30876.exe'
$checksum     = '38fe37627a93f2904bb2a77769b1ffe53e833d84f3e1ddca768c573c298d39fc'
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
