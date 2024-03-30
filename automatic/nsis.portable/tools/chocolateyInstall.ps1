$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  Destination    = $toolsDir
  FileFullPath   = "$toolsDir\nsis-3.10.zip"
}

Get-ChocolateyUnzip  @packageArgs
