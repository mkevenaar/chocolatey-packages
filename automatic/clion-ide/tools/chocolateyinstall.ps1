$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/cpp/CLion-2018.3.exe'
$checksum     = '7c4a4388b34b315e445ba7c661db62a637b1af84bf3407535803ddf0b0b28f50'
$checksumType = 'sha256'
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName   = 'JetBrains Clion*'
  fileType      = 'exe'
  silentArgs    = "/S /CONFIG=$toolsDir\silent.config "
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

 Install-ChocolateyPackage @packageArgs	
