$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file          = "$toolsDir\exiftool-12.96_32.zip"
  file64        = "$toolsDir\exiftool-12.96_64.zip"
}

Get-ChocolateyUnzip  @packageArgs

Get-ChildItem -Path $toolsDir\*\exiftool*.exe | Rename-Item -NewName exiftool.exe

Get-ChildItem $toolsDir\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
