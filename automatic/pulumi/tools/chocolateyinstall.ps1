$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\pulumi-v0.17.24-windows-x64.zip"
}

Install-ChocolateyZipPackage  @packageArgs

