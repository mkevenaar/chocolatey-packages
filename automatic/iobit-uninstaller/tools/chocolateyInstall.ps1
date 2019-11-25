$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://update.iobit.com/dl/iobituninstaller.exe'
$checksum     = '9852FB8E3A2F01A13A86F8487DA011EBB3CC2BA39D54B9BC5EE450344816AC23'
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
