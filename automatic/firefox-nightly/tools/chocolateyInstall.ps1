﻿$ErrorActionPreference = 'Stop'
# This is the general install script for Mozilla products (Firefox and Thunderbird).
# This file must be identical for all Choco packages for Mozilla products in this repository.
$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$packageName = 'firefox-nightly'
$softwareName = 'Nightly'

#$alreadyInstalled = (AlreadyInstalled -product $softwareName -version '146.0a1')

if (Get-32bitOnlyInstalled -product $softwareName) {
  Write-Output $(
    'Detected the 32-bit version of Firefox on a 64-bit system. ' +
    'This package will continue to install the 32-bit version of Firefox ' +
    'unless the 32-bit version is uninstalled.'
  )
}

#if ($alreadyInstalled -and ($env:ChocolateyForce -ne $true)) {
#  Write-Output $(
#    "Firefox is already installed. " +
#    'No need to download and re-install.'
#  )
#} else {
  $locale = 'en-US' #https://github.com/chocolatey/chocolatey-coreteampackages/issues/933
  $locale = GetLocale -localeFile "$toolsPath\LanguageChecksums.csv" -product $softwareName
  $checksums = GetChecksums -language $locale -checksumFile "$toolsPath\LanguageChecksums.csv"

  $packageArgs = @{
    packageName = $packageName
    fileType = 'exe'
    softwareName = "$softwareName*"

    Checksum = $checksums.Win32
    ChecksumType = 'sha512'
    Url = "https://archive.mozilla.org/pub/firefox/nightly/2025/10/2025-10-26-20-42-57-mozilla-central/firefox-146.0a1.${locale}.win32.installer.exe"

    silentArgs = '-ms'
    validExitCodes = @(0)
  }

  if (!(Get-32bitOnlyInstalled($softwareName)) -and (Get-OSArchitectureWidth 64)) {
    $packageArgs.Checksum64 = $checksums.Win64
    $packageArgs.ChecksumType64 = 'sha512'
    $packageArgs.Url64 = "https://archive.mozilla.org/pub/firefox/nightly/2025/10/2025-10-26-20-42-57-mozilla-central/firefox-146.0a1.${locale}.win64.installer.exe"
  }

  Install-ChocolateyPackage @packageArgs
#}
