$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file64        = "$toolsDir\SuperPuTTY-CE-1.8.5-portable-win-x64.zip"
}

Get-ChocolateyUnzip @packageArgs

Get-ChildItem -Path "$toolsDir\*.zip" | ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue; if (Test-Path -LiteralPath $_.FullName) { Set-Content -Path "$($_.FullName).ignore" -Value '' } }
