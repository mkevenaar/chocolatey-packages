$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  file          = "$toolsDir\OrcaSlicer_Windows_Installer_V2.3.1-beta.exe"
  fileType      = 'exe'
  softwareName  = 'OrcaSlicer*'
  silentArgs    = "/S"
  validExitCodes= @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs

