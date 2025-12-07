$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file          = "$toolsDir\helio-3.17-x32.zip"
  file64        = "$toolsDir\helio-3.17-x64.zip"
}

Get-ChocolateyUnzip @packageArgs
