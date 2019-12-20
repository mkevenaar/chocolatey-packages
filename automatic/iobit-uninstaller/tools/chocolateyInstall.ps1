$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://update.iobit.com/dl/iobituninstaller.exe'
$checksum     = '0274144899085364DA7C4573459B162785E7828C2AB512652DBE1F053A87A7AC'
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
