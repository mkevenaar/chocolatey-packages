$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/devmanview.zip'
$checksum32     = '991a790b16a9d5830a7427ca3b534581b57c2d505fbafda466b94de5717cf2c4'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/devmanview-x64.zip'
$checksum64     = '2608d1373069ecee11b635293b13419dbb7644435a0cc47cdb398c3dd0496809'
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
