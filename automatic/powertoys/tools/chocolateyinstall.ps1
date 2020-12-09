$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileName       = "$toolsDir\PowerToysSetup-0.27.1-x64.exe"
$version        = "0.27.1"

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
  file          = $fileName
  fileType      = 'exe'
  silentArgs    = "--silent --skip_dotnet_install"
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs

