$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file           = "$toolsdir\texstudio-4.9.1-win-portable-qt6.zip"
}

Get-ChocolateyUnzip  @packageArgs

Get-ChildItem $toolsPath\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

