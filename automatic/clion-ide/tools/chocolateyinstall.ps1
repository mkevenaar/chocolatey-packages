$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/cpp/CLion-2024.1.2.exe'
$checksum     = 'a0fa6258919af9340d1cf7e5a770cd796e3291ce88556c2986569b4222b4e237'
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
