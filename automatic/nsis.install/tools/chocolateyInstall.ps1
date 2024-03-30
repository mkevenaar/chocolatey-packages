$ErrorActionPreference = 'Stop';
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  file           = "$toolsDir\nsis-3.10-setup.exe"
  fileType       = 'exe'
  softwareName   = 'Nullsoft Install System*'
  silentArgs     = '/S'
  validExitCodes = @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
