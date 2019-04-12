$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  file           = "$toolsDir\SimulIDE_0.3.10_SR1-Win32.7z"
}

Get-ChocolateyUnzip @packageArgs

$bindir = Join-Path -Path ($packageArgs.file -replace ".7z") -ChildPath "bin"

# create empty sidecar so shimgen ignores them.
Set-Content -Path (Join-Path -Path $bindir -ChildPath "simulide.exe.ignore") -Value $null
Set-Content -Path (Join-Path -Path $bindir -ChildPath "avra.exe.ignore") -Value $null
Set-Content -Path (Join-Path -Path $bindir -ChildPath "gpasm.exe.ignore") -Value $null
