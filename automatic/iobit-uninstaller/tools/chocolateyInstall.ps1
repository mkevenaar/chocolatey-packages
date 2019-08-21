$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://update.iobit.com/dl/iobituninstaller.exe'
$checksum     = 'AC56D1F9FFB7ACB252AFBA42F3D2571B14B41BD781225DDACA5C73F65D90F83C'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'IObit Uninstaller*'
  fileType      = 'exe'
  silentArgs    = "/sp- /verysilent /suppressmsgboxes /install_start"
  validExitCodes= @(0,3010)
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
