$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.6856.exe'
$checksum     = 'b99666d3b413af1770541ef022379d5ab7a6a52ac0d870aff17a1b53c6365761'
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
