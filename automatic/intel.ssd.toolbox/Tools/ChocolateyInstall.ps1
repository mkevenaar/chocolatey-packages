$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://downloadmirror.intel.com/29723/eng/Intel%20SSD%20Toolbox%20-%20v3.5.14.exe'
$checksum     = 'ebeb0aff99aa3b09be23784437ede31367b392d0c3a6a7df8495fc608ed9412a'
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
