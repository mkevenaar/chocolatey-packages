﻿$ErrorActionPreference = 'Stop'
# This is the general install script for Mozilla products (Firefox and Thunderbird).
# This file must be identical for all Choco packages for Mozilla products in this repository.
$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$packageName = 'firefox-dev'
$softwareName = 'Firefox Developer Edition'

$alreadyInstalled = (AlreadyInstalled -product $softwareName -version '145.0b9')

if (Get-32bitOnlyInstalled -product $softwareName) {
  Write-Output $(
    'Detected the 32-bit version of Firefox on a 64-bit system. ' +
    'This package will continue to install the 32-bit version of Firefox ' +
    'unless the 32-bit version is uninstalled.'
  )
}

if ($alreadyInstalled -and ($env:ChocolateyForce -ne $true)) {
  Write-Output $(
    "Firefox is already installed. " +
    'No need to download and re-install.'
  )
} else {
  $locale = 'en-US' #https://github.com/chocolatey/chocolatey-coreteampackages/issues/933
  $locale = GetLocale -localeFile "$toolsPath\LanguageChecksums.csv" -product $softwareName
  $checksums = GetChecksums -language $locale -checksumFile "$toolsPath\LanguageChecksums.csv"

  $packageArgs = @{
    packageName = $packageName
    fileType = 'exe'
    softwareName = "$softwareName*"

    Checksum = $checksums.Win32
    ChecksumType = 'sha512'
    Url = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/145.0b9/win32/${locale}/Firefox%20Setup%20145.0b9.exe"

    silentArgs = '-ms'
    validExitCodes = @(0)
  }

  if (!(Get-32bitOnlyInstalled($softwareName)) -and (Get-OSArchitectureWidth 64)) {
    $packageArgs.Checksum64 = $checksums.Win64
    $packageArgs.ChecksumType64 = 'sha512'
    $packageArgs.Url64 = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/145.0b9/win64/${locale}/Firefox%20Setup%20145.0b9.exe"
  }

  Install-ChocolateyPackage @packageArgs
}
