$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.ultraiso.com/uiso9_pe.exe'
$checksum     = '26e3139f6ac209981c0ed5fd95d4e0c43f7dd82eeddaaf3e6585cbfcb0f95ca3'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'UltraISO*'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
