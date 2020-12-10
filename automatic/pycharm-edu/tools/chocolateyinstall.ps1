$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.jetbrains.com/python/pycharm-edu-2020.3.exe' 
$checksum     = '94c6c3b598ad44319282755962ce802a7053d684899d1d7f8fb3f272dd6b5716'
$checksumType = 'sha256'

# Workaround for https://youtrack.jetbrains.com/issue/IDEA-202935
$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
New-Item -ItemType Directory -Force -Path $programfiles\JetBrains
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName   = "PyCharm Edu*"
  fileType      = 'exe'
  silentArgs    = "/S /CONFIG=$toolsDir\silent.config "
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

 Install-ChocolateyPackage @packageArgs	
