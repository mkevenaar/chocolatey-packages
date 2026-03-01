$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  file          = "$toolsDir\ORCaSlicer_Windows_Installer_V2.3.2-RC.exe"
  fileType      = 'exe'
  softwareName  = 'OrcaSlicer*'
  silentArgs    = "/S"
  validExitCodes= @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs

