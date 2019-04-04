$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://downloadmirror.intel.com/28674/eng/Intel%20SSD%20Toolbox%20-%20v3.5.10.exe'
$checksum     = '1EBD356C1A1783CFF8AB957EDC0517F80844ABCFCE9E5B89D845546B3F752C19'
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
