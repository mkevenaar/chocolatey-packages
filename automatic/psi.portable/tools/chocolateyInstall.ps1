$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\psi-portable-1.4_win7_x86.7z"
  file64        = "$toolsDir\psi-portable-1.4_win7_x86_64.7z"
}

Get-ChocolateyUnzip  @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "psi-portable.exe.gui"
Set-Content -Path $installFile `
            -Value $null
