$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://downloadmirror.intel.com/30161/eng/Intel%C2%AEMAS_Tool_GUI_1.5.zip'
$checksum     = '51dc88e6770a7dec26de8107bb1d6c6533b02c0db37eb294f832f6c2b135223c'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  destination    = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = Get-Item $toolsDir\*.exe
  softwareName   = 'Intel® Memory and Storage Tool*'
  silentArgs     = "/qn"
  validExitCodes = @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs
