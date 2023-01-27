$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/alternatestreamview.zip'
$checksum32     = '6a4600134b0b3f641b5b2694315c32db71f11b2d22aaeac027ae55101033d0b1'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/alternatestreamview-x64.zip'
$checksum64     = 'ad1f0edb2202ec1a736d9266b18b241eac5542c350578a3a8cdb4dd8b14ff37d'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
}

Install-ChocolateyZipPackage  @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "alternatestreamview.exe.gui"
Set-Content -Path $installFile `
            -Value $null
