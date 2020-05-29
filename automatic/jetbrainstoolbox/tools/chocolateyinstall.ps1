$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7005.exe'
$checksum     = '77f41f1e0df016568ef31a78392d6e6b781a557ab2fe2942416414d7e9f2170a'
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
