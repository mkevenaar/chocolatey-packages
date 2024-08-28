$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  fileFullPath   = "$toolsdir\orientdb-community-3.2.33.zip"
}

Get-ChocolateyUnzip @packageArgs
