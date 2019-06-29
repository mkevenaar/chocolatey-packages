$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/alternatestreamview.zip'
$checksum32     = '81002363eaf793c149927677a2ccb073554e632013c0b3b1d231b4590c78fb73'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/alternatestreamview-x64.zip'
$checksum64     = '9b7d09b3db143585b3ff06fedf954a2ae8d40a704952620927420cddc28759e3'
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
