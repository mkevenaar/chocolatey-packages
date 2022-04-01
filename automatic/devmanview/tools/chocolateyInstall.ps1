$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/devmanview.zip'
$checksum32     = '44b14fd19e6752b5f29b1e00e16482d9a3b852f47bc8280cda25d7c7e4a5c6a8'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/devmanview-x64.zip'
$checksum64     = 'a7dd51ea5ab57fe2f686fbb8dc0d5e96207d77d317da9e83c636f98bda4c5a4c'
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
                         -ChildPath "devmanview.exe.gui"
Set-Content -Path $installFile `
            -Value $null
