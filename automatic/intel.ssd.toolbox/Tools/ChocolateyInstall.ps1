$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://downloadmirror.intel.com/29981/eng/Intel%20SSD%20Toolbox%20-%20v3.5.15.exe'
$checksum     = 'c413e0f323d63bbe7bc41befe9557e003ee440c32633b94ade1f632d3489f792'
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
