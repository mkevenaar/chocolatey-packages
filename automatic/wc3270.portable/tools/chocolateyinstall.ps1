$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\wc3270-4.3ga8-noinstall-32.zip"
  file64        = "$toolsDir\wc3270-4.3ga8-noinstall-64.zip"
}

Get-ChocolateyUnzip @packageArgs

