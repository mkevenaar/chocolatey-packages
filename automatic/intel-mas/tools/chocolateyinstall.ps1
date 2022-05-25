$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://downloadmirror.intel.com/690883/Intel_MAS_GUI_Tool_Win_2.0.zip'
$checksum     = '00f641e1ec7823c9a4bdb8fe5a7d641b1744e9a802f3ffe11fe2cf3324bc2090'
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
