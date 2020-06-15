$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x86.msi'
$checksum32     = '275B70675B231502D93602E3624524029FDD3E4E910A4B2DAA9AB64CE6EB9D67'
$checksumType32 = 'sha256'
$url64          = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x64.msi'
$checksum64     = '5bb85791ff837844f974b46e39bc4a33cc96b1e758acf36687603af749e41a14'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'Server Backup Agent*'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs
