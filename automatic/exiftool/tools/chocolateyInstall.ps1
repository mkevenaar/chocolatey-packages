$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file          = "$toolsDir\exiftool-13.59_32.zip"
  file64        = "$toolsDir\exiftool-13.59_64.zip"
}

Get-ChocolateyUnzip  @packageArgs

Get-ChildItem -Path $toolsDir\*\exiftool*.exe | Rename-Item -NewName exiftool.exe

Get-ChildItem -Path $toolsDir -Recurse -Filter 'exiftool_files' |
  Where-Object { $_.PSIsContainer } |
  ForEach-Object {
    Get-ChildItem -Path $_.FullName -Recurse -Filter '*.exe' |
      Where-Object { -not $_.PSIsContainer } |
      ForEach-Object { Set-Content "$($_.FullName).ignore" }
  }

Get-ChildItem $toolsDir\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
