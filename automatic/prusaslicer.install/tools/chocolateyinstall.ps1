$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  file          = "$toolsDir\prusa3d_win_2_9_3_x64.exe"
  fileType      = 'exe'
  softwareName  = 'PrusaSlicer*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /NOICONS"
  validExitCodes= @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs

