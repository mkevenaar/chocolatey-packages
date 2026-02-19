$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.jetbrains.com/go/goland-2025.3.3.exe'
$checksum     = 'f540191f6db015a9ceec5ba3318bcabff1597d3b8596a8188dfd8908874b694e'
$checksumType = 'sha256'

# Workaround for https://youtrack.jetbrains.com/issue/IDEA-202935
$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
New-Item -ItemType Directory -Force -Path $programfiles\JetBrains
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'GoLand*'
  fileType      = 'exe'
  silentArgs    = "/S /CONFIG=$toolsDir\silent.config "
  validExitCodes= @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
