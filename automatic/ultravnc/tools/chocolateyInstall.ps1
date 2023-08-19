$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = "$toolsDir\UltraVNC_1431_X86_Setup.exe"
  file64        = "$toolsDir\UltraVNC_1431_X64_Setup.exe"
  softwareName  = 'UltraVnc*'
  silentArgs    = '/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS'
  validExitCodes= @(0,3010)
}

$pp = Get-PackageParameters
if ($pp['LoadInf']) {
  if (!(Test-Path $pp['LoadInf'])) { throw "$($pp['LoadInf']) is not a valid file" }
  $packageArgs['silentArgs'] += " /LOADINF:$($pp['LoadInf'])"
}

Install-ChocolateyInstallPackage @packageArgs
Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
