$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  file           = "$toolsdir\MediaInfo_CLI_26.01_Windows_i386.zip"
  file64         = "$toolsdir\MediaInfo_CLI_26.01_Windows_x64.zip"
  validExitCodes = @(0)
}

Write-Verbose "Downloading and installing program..."
Get-ChocolateyUnzip  @packageArgs

Get-ChildItem $toolsPath\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
