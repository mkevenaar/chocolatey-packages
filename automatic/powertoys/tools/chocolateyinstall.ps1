$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version        = "0.70.1"
$url64 = 'https://github.com/microsoft/PowerToys/releases/download/v0.70.1/PowerToysSetup-0.70.1-x64.exe'
$checksum64 = '1be4760558765ef363e12126282f1e3340a8adff657c5c51714f7e096f86ee50'

$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10."
}

$IsCorrectBuild=[Environment]::OSVersion.Version.Build
if ($IsCorrectBuild -lt "17134") {
  throw "This package requires at least Windows 10 version 1803/OS build 17134.x."
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'PowerToys*'
  url64         = $url64
  checksum64    = $checksum64
  checksumType64= 'sha256'
  fileType      = 'exe'
  silentArgs    = "-silent"
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
