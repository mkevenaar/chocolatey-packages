$ErrorActionPreference = 'Stop'

if (Test-Path -Path $env:ProgramFiles\IrfanView\iv_uninstall.exe) {
  &$env:ProgramFiles\IrfanView\iv_uninstall.exe /silent
}
else {
  &${env:ProgramFiles(x86)}\IrfanView\iv_uninstall.exe /silent
}

