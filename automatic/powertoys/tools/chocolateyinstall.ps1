$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version        = "0.83.0"
$url64 = 'https://github.com/microsoft/PowerToys/releases/download/v0.83.0/PowerToysSetup-0.83.0-x64.exe'
$checksum64 = '7ec435a10849187d21a383e56a69213c1ff110b7feca65900d9319d2f8162f35'

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
