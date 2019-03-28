$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\Wireshark-win32-3.0.0.exe"
  file64        = "$toolsDir\Wireshark-win64-3.0.0.exe"
  softwareName  = 'Wireshark*'
  silentArgs     = '/S /quicklaunchicon=no'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

