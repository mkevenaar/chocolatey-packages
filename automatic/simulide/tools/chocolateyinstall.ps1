$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  file           = "$toolsDir\SimulIDE_0.3.10_SR1-Win32.7z"
}

Get-ChocolateyUnzip @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "simulide.exe.gui"
Set-Content -Path $installFile `
            -Value $null
