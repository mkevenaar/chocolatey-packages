$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/cpp/CLion-2025.2.3.exe'
$checksum     = '69cc54fe0c2b05adb618878fbdccca63750868913e28d94793e3644a16e13d30'
$checksumType = 'sha256'

# Workaround for https://youtrack.jetbrains.com/issue/IDEA-202935
$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
New-Item -ItemType Directory -Force -Path $programfiles\JetBrains
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName   = 'CLion*'
  fileType      = 'exe'
  silentArgs    = "/S /CONFIG=$toolsDir\silent.config "
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

 Install-ChocolateyPackage @packageArgs	
