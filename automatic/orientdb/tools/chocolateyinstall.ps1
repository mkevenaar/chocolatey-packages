$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  fileFullPath   = "$toolsdir\orientdb-3.1.9.zip"
}

Get-ChocolateyUnzip @packageArgs
