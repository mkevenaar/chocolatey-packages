$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/alternatestreamview.zip'
$checksum32     = '922308e42762c7fb7ff31984f308a6294ed210907b40adf79c743ca83ebe6c59'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/alternatestreamview-x64.zip'
$checksum64     = 'c0c5fa2e055e0774e1976d78b9f87c20b657504ef764adc31c03ef4c88513631'
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
