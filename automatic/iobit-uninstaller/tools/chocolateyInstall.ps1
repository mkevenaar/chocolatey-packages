$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://cdn.iobit.com/dl/iobituninstaller.exe'
$checksum     = '5400C987D02C3F4B159CB5B11B432971379901FD79A90FDDD1E70FA0D98E7DE5'
$checksumType = 'sha256'

. $toolsDir\helpers.ps1

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

$pp = Get-PackageParameters
$mergeTasks = Get-MergeTasks $pp
$packageArgs.silentArgs += ' /MERGETASKS="{0}"' -f $mergeTasks

Install-ChocolateyPackage @packageArgs
