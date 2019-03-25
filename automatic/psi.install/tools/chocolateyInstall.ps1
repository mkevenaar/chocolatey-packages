$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = "$toolsDir\psi-1.3-win64-setup.exe"
  softwareName  = 'Psi*'
  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

