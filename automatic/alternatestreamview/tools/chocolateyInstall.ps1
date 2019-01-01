$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://www.nirsoft.net/utils/alternatestreamview.zip'
$checksum32     = '01f7212a8d389fc53769065d532580839330d302f063e31489cef59a61f367bb'
$checksumType32 = 'sha256'
$url64          = 'http://www.nirsoft.net/utils/alternatestreamview-x64.zip'
$checksum64     = '834106f2145fe6587bb1beac75576b3b823482860e0309a2ee2e0417f220b449'
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
