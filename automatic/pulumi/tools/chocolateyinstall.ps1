$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file64         = "$toolsDir\pulumi-v1.5.1-windows-x64.zip"
}

Install-ChocolateyZipPackage  @packageArgs
