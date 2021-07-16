$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.21.9547.exe'
$checksum     = '35b10e97cf3206a2507e4824cb58b24773befbd233eb0409369183e87e628be9'
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
