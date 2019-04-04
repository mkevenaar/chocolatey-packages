$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://downloadmirror.intel.com/28674/eng/Intel%20SSD%20Toolbox%20-%20v3.5.10.exe'
$checksum     = '1ebd356c1a1783cff8ab957edc0517f80844abcfce9e5b89d845546b3f752c19'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'Intel SSD*'
  silentArgs    = "/s"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
