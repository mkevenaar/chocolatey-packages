$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileName       = "$toolsDir\Microsoft.WindowsTerminal_0.2.1831.0_8wekyb3d8bbwe.msixbundle"

$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10."
}
#The .msixbundle format is not supported on Windows 10 version 1709 and 1803. https://docs.microsoft.com/en-us/windows/msix/msix-1709-and-1803-support
$IsCorrectBuild=[Environment]::OSVersion.Version.Build
if ($IsCorrectBuild -lt "17763") {
  throw "This package requires at least Windows 10 version 1809/OS build 17763.x."
}

Add-AppxPackage -Path $fileName
