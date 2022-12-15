$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://downloadmirror.intel.com/763558/Intel_MAS_GUI_Tool_Win_2.2.zip'
$checksum     = 'd4d95878974c75ea89397e35f6d6a3f19c746206d4f37b323bcf53b18e920638'
$checksumType = 'sha256'

# Cleanup old files, if exist
Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
Get-ChildItem $toolsDir\*.pdf | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = Get-Item $toolsDir\*.exe
  softwareName   = 'Intel® Memory and Storage Tool*'
  silentArgs     = "/qn"
  validExitCodes = @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs
