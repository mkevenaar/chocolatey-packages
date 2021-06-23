$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/devmanview.zip'
$checksum32     = 'a5bb46d077db9662d4eaa16a85636b1a6a75786f7cf0f089197f5efa86d65948'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/devmanview-x64.zip'
$checksum64     = 'fb4eff5b3730a4014aa4406f4ad49a658761a8ebff43b6613bfcd3cd739768d1'
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
