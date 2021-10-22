$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://downloadmirror.intel.com/682010/Intel_MAS_GUI_Tool_Win_1.11.zip'
$checksum     = '97df7c045aef291f6ad7a20096d98a8475255cd5522f3ff98c2c7408a5c71797'
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
