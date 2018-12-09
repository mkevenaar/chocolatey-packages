$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://update.iobit.com/dl/iobituninstaller.exe'
$checksum     = '110e83c2ed71069addd412081f5dd4429add6941193fd50c632585d512fc2d94'
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
