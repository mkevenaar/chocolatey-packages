$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\helio-3.9-x32.zip"
  file64        = "$toolsDir\helio-3.9-x64.zip"
}

Install-ChocolateyZipPackage  @packageArgs

