$ErrorActionPreference = 'Stop';

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  Destination    = $toolsDir
  FileFullPath   = "$toolsDir\SimulIDE_1.1.0-SR2_Win32.zip"
  FileFullPath64 = "$toolsDir\SimulIDE_1.1.0-SR2_Win64.zip"
}

Get-ChocolateyUnzip @packageArgs

$archivePath = $packageArgs.FileFullPath
if ((Get-OSArchitectureWidth -Compare 64) -and $env:ChocolateyForceX86 -ne 'true' -and $packageArgs.FileFullPath64) {
  $archivePath = $packageArgs.FileFullPath64
}
$applicationDir = Join-Path -Path $toolsDir -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($archivePath))

# Ignore the GUI and bundled helpers, wherever they are in the archive.
Get-ChildItem -LiteralPath $applicationDir -Filter '*.exe' -Recurse -File | ForEach-Object {
  Set-Content -LiteralPath "$($_.FullName).ignore" -Value $null
}
