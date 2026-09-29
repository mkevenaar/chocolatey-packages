$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

Get-Process telegram -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
Remove-Item $toolsPath\*.zip -ErrorAction SilentlyContinue
