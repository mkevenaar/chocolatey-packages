$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/devmanview.zip'
$checksum32     = 'd38d56c181c181ef8f57f3c75e697967f046c571e7b7125e11d15661288f9c61'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/devmanview-x64.zip'
$checksum64     = 'a6e6b5ed9459302c63778012676cb8a183a1adfb0252f6f3a441f5aa5385e757'
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
